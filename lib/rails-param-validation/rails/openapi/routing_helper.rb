module RailsParamValidation
  class Formatter < ActionDispatch::Journey::Visitors::FunctionalVisitor
    def binary(node, seed)
      visit(node.right, visit(node.left, seed))
    end

    def nary(node, seed)
      node.children.inject(seed) { |s, c| visit(c, s) }
    end

    def terminal(node, seed)
      seed.map { |s| s + node.left }
    end

    def visit_GROUP(node, seed)
      visit(node.left, seed.dup) + seed
    end

    def visit_SYMBOL(node, seed)
      name = node.left
      name = name[1..-1] if name[0] == ":"
      seed.map { |s| s + "{#{name}}" }
    end
  end

  class RoutingHelper
    def self.routes_for(controller, action)
      routes = []
      Rails.application.routes.routes.each do |route|
        if route.defaults[:controller] == controller && route.defaults[:action] == action
          Formatter.new.accept(route.path.ast, [""]).each do |path|
            routes.push(path: path, method: route.verb)
          end
        end
      end

      routes
    end
  end
end
