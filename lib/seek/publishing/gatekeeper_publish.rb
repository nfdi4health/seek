module Seek
  module Publishing
    module GatekeeperPublish
      def self.included(base)
        base.before_action :set_gatekeeper, only: [:requested_approval_assets, :gatekeeper_decide]
        base.before_action :gatekeeper_auth, only: [:requested_approval_assets, :gatekeeper_decide]
        base.before_action :gatekeeper_validate_json_params, only: [:gatekeeper_decide], if: :json_api_request?
        base.before_action :gatekeeper_convert_json_params, only: [:gatekeeper_decide], if: :json_api_request?
      end

      def requested_approval_assets
        @requested_approval_assets = ResourcePublishLog.requested_approval_assets_for(@gatekeeper)
        respond_to do |format|
          format.html { render template: 'assets/publishing/requested_approval_assets' }
          format.json do
            render json: @requested_approval_assets, status: 200
          end
        end
      end

      def gatekeeper_decide
        resolve_items_params params[:gatekeeper_decide]
        @problematic_items = @approve_items.select { |item| !item.publish!(params[:gatekeeper_decide]["#{item.class.name}"]["#{item.id}"]['comment']) }

        deliver_gatekeeper_approval_feedback(@approve_items - @problematic_items)
        deliver_gatekeeper_reject_feedback(@reject_items)

        @reject_items.each do |item|
          item.reject params[:gatekeeper_decide]["#{item.class.name}"]["#{item.id}"]['comment']
        end

        respond_to do |format|
          flash[:notice] = 'Decision making complete!'
          format.html { render template: 'assets/publishing/gatekeeper_decision_result' }

          json_response =  'approved_ids:'+ (@approve_items - @problematic_items).map(&:id).to_s
          json_response += 'rejected_ids:'+ @reject_items.map(&:id).to_s
          format.json do
            render json: json_response, status: 200
          end
        end
      end

      private

      def set_gatekeeper
        @gatekeeper = current_user.try(:person)
      end

      # checks that the person is a gatekeeper, regardless of project. Later when collecting the assets, they are filtered down to only thsoe the gatekeeper can control.
      def gatekeeper_auth
        if @gatekeeper.nil? || !@gatekeeper.is_asset_gatekeeper_of_any_project?
          error('You are not authorized to approve/reject the publishing of items. You might login as a gatekeeper.', 'is invalid (insufficient_privileges)')
          return false
        end
      end

      def deliver_gatekeeper_approval_feedback(items)
        if Seek::Config.email_enabled
          requesters_items_comments = requesters_items_and_comments(items)
          requesters_items_comments.keys.each do |requester_id|
            requester = Person.find_by_id(requester_id)
            begin
              Mailer.gatekeeper_approval_feedback(requester, @gatekeeper, requesters_items_comments[requester_id]).deliver_later
            rescue Exception => e
              Rails.logger.error("Error sending gatekeeper approval feedback email to the requester #{requester.name}- #{e.message}")
            end
          end
        end
      end

      def deliver_gatekeeper_reject_feedback(items)
        if Seek::Config.email_enabled
          requesters_items_comments = requesters_items_and_comments(items)
          requesters_items_comments.keys.each do |requester_id|
            requester = Person.find_by_id(requester_id)
            begin
              Mailer.gatekeeper_reject_feedback(requester, @gatekeeper, requesters_items_comments[requester_id]).deliver_later
            rescue Exception => e
              Rails.logger.error("Error sending gatekeeper reject feedback email to the requester #{requester.name}- #{e.message}")
            end
          end
        end
      end

      def requesters_items_and_comments(items)
        requesters_items_and_comments = {}
        items.each do |item|
          item.publish_requesters.collect(&:id).each do |requester_id|
            requesters_items_and_comments[requester_id] ||= []
            requesters_items_and_comments[requester_id] << { item: item,
                                                             comment: params[:gatekeeper_decide]["#{item.class.name}"]["#{item.id}"]['comment'] }
          end
        end
        requesters_items_and_comments
      end

      def resolve_items_params(param)
        @approve_items = []
        @reject_items = []
        @decide_later_items = []

        return if param.nil?

        param.keys.each do |asset_class|
          klass = asset_class.constantize
          param[asset_class].keys.each do |id|
            asset = klass.find_by_id(id)
            decision = param[asset_class][id]['decision']
            case decision.to_i
            when 1
              @approve_items << asset
            when 0
              @reject_items << asset
            when -1
              @decide_later_items << asset
            end
          end
        end
        # filter only authorized items for making decision
        requested_approval_assets = ResourcePublishLog.requested_approval_assets_for @gatekeeper
        @approve_items &= requested_approval_assets
        @reject_items &= requested_approval_assets
        @decide_later_items &= requested_approval_assets

        @approve_items.uniq!
        @reject_items.uniq!
        @decide_later_items.uniq!
      end

      def gatekeeper_validate_json_params
        params['data'].each do |data|
          id = data['resource']['id']
         StudyhubResource.find(id)
        rescue ActiveRecord::RecordNotFound
           error("The resource #{id} is not found", 'not found resource')
           break
        end
      end

      def gatekeeper_convert_json_params

        params['gatekeeper_decide'] = {}
        params['gatekeeper_decide']['StudyhubResource'] = {}

        resources = {}
        params['data'].each do |data|
          id = data['resource']['id']
          resources[id] ={}
          resources[id]['decision']= convert_decision_action(data['action'])
          resources[id]['comment']= data['comment']
        end

        params['gatekeeper_decide']['StudyhubResource'] = resources
        params.delete(:data)
      end

      def convert_decision_action(action)
        case action
        when 'approve'
          1
        when 'reject'
          0
        when 'decide_later'
          -1
        else
          'wrong'
        end
      end

    end
  end
end
