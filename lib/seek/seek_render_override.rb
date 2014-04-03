
module ActionView
  class Renderer

    @@map = {}

    def self.define_alternative key,value
      @@map[key]=value
    end

    def render(context, options)
      options = check_for_override(context,options)
      if options.key?(:partial)
        render_partial(context, options)
      else
        render_template(context, options)
      end
    end

    def check_for_override context, options
      unless options[:seek_template].nil?
        key = {:controller => context.controller_name.to_sym, :seek_template => options[:seek_template].to_sym}
        unless @@map[key].nil?
          options[:template]=@@map[key].to_s
        end
      end

      unless options[:seek_partial].nil?
        key = {:controller => context.controller_name.to_sym, :seek_partial => options[:seek_partial].to_sym}
        key = {:seek_partial => options[:seek_partial].to_s} if @@map[key].nil?
        if @@map[key].nil?
          options[:partial]= options[:seek_partial]
        else
          options[:partial]=@@map[key].to_s
        end
      end
      options
    end
  end
end