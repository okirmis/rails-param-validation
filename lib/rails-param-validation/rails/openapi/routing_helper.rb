module RailsParamValidation
  class RoutingHelper
    def self.routes_for(controller, action)
      routes = []
      Rails.application.routes.routes.each do |route|
        if route.defaults[:controller] == controller && route.defaults[:action] == action
          path = RoutingHelper.build_path(route.path.build_formatter, include_format: !RailsParamValidation.openapi.skip_format_endpoints)
          routes.push(path: path, method: route.verb)
        end
      end

      routes
    end

    def self.build_path(formatter, include_format:)
      parts = formatter.instance_variable_get(:@parts).map do |part|
        case part
        when String
          part
        when ActionDispatch::Journey::Format::Parameter
          "{#{part.name}}"
        when ActionDispatch::Journey::Format
          if include_format
            build_path(part, include_format: true)
          else
            nil
          end
        else
          nil
        end
      end

      parts.reject(&:nil?).join
    end
  end
end
