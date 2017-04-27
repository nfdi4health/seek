require 'test_helper'

class AssetButtonsTest < ActionDispatch::IntegrationTest

  include HtmlHelper

  ASSETS = %w(investigations studies assays data_files models sops strains presentations events)
  def setup
    User.current_user = Factory(:user, login: 'test')
    @current_user = User.current_user
    post '/session', login: 'test', password: 'blah'
    stub_request(:head, 'http://somewhere.com/piccy.pdf').to_return(status: 404)
    stub_request(:head, 'http://www.abc.com/').to_return(status: 404)
    stub_request(:head, 'http://somewhere.com/piccy_no_copy.pdf').to_return(status: 404)
  end

  test 'show delete' do
    ASSETS.each do |type_name|
      if type_name == 'assays'
        contributor = @current_user.person
        human_name = I18n.t('assays.modelling_analysis').humanize
      else
        contributor = @current_user
        human_name = type_name.singularize.humanize
      end
      item = Factory(type_name.singularize.to_sym, contributor: contributor,
                     policy: Factory(:all_sysmo_viewable_policy))
      assert item.can_delete?, 'This item is deletable for the test to pass'

      get "/#{type_name}/#{item.id}"
      assert_response :success
      assert_select '#buttons' do
        assert_select 'a', text: /Delete #{human_name}/i
      end

      delete "/#{type_name}/#{item.id}"
      assert_redirected_to eval("#{type_name}_path"), 'Should redirect to index page after deleting'
      assert_nil flash[:error]
    end
  end

  test 'configurable showing as external link when there is no local copy' do
    pdf_blob_with_local_copy_attrs = { url: 'http://somewhere.com/piccy.pdf', uuid: UUID.generate,
                                       data: File.new("#{Rails.root}/test/fixtures/files/a_pdf_file.pdf", 'rb').read }
    pdf_blob_without_local_copy_attrs = { data: nil, url: 'http://somewhere.com/piccy_no_copy.pdf', uuid: UUID.generate }
    html_blob_attrs = { data: nil, url: 'http://www.abc.com', uuid: UUID.generate }

    Seek::Util.inline_viewable_content_types.each do |klass|
      underscored_type_name = klass.name.underscore

      with_config_value :show_as_external_link_enabled, true do
        if Seek::Util.is_multi_file_asset_type? klass
          remote_with_local = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                      content_blobs: [Factory(:content_blob, pdf_blob_with_local_copy_attrs)])
          remote_without_local = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                         content_blobs: [Factory(:content_blob, pdf_blob_without_local_copy_attrs)])
          mixed = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                          content_blobs: [Factory(:content_blob, pdf_blob_with_local_copy_attrs),
                                          Factory(:content_blob, pdf_blob_without_local_copy_attrs)])
          pdf_and_html_remote = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                        content_blobs: [Factory(:content_blob, html_blob_attrs),
                                                        Factory(:content_blob, pdf_blob_without_local_copy_attrs)])

          assert_download_button remote_with_local
          assert_link_button remote_without_local
          assert_download_button mixed
          assert_neither_download_nor_link_button pdf_and_html_remote
        else
          remote_with_local = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                      content_blob: Factory(:content_blob, pdf_blob_with_local_copy_attrs))
          html_remote = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                content_blob: Factory(:content_blob, html_blob_attrs))
          remote_without_local = Factory(underscored_type_name.to_sym, policy: Factory(:all_sysmo_downloadable_policy),
                                         content_blob: Factory(:content_blob, pdf_blob_without_local_copy_attrs))

          assert_download_button remote_with_local
          assert_link_button html_remote
          assert_link_button remote_without_local
        end
      end
    end
  end

  private

  def create_content_blobs(asset, multi_attrs)
    asset.content_blobs.clear
    multi_attrs.each do |attrs|
      asset.content_blobs.create attrs
    end
  end

  def assert_neither_download_nor_link_button(item)
    get "/#{item.class.name.underscore.pluralize}/#{item.id}"
    assert_response :success
    assert_select '#buttons' do
      assert_select 'a', text: 'Download', count: 0
      assert_select 'a', text: 'External Link', count: 0
    end
  end

  def assert_link_button(item)
    assert_action_button item, 'External Link'
  end

  def assert_download_button(item)
    assert_action_button item, 'Download'
  end

  def assert_action_button(item, text)
    get "/#{item.class.name.underscore.pluralize}/#{item.id}"
    assert_response :success

    pp item
    puts
    pp (item.respond_to?(:content_blobs) ? item.content_blobs : item.content_blob)
    puts
    puts select_node_contents('#buttons')
    puts '-'*10
    puts

    assert_select '#buttons' do
      assert_select 'a', { text: text }, "Couldn't find '#{text}' button at #{path}"
    end
  end
end
