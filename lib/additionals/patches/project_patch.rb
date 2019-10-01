module Additionals
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:prepend, InstancOverwriteMethods)
        base.send(:include, InstanceMethods)
      end

      module InstancOverwriteMethods
        def users_by_role
          roles_with_users = super
          roles_with_users.each do |role_with_users|
            role = role_with_users.first
            next unless role.hide

            roles_with_users.delete(role) unless User.current.allowed_to?(:show_hidden_roles_in_memberbox, project)
          end

          roles_with_users
        end
      end

      module InstanceMethods
        def visible_principals
          query = ::Query.new(project: self, name: '_')
          query&.principals
        end

        def visible_users
          query = ::Query.new(project: self, name: '_')
          query&.users
        end
      end
    end
  end
end
