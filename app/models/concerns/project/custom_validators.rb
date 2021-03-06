module Project::CustomValidators
  extend ActiveSupport::Concern

  included do
    @@routes = Rails.application.routes.routes
    validate :permalink_cant_be_route
    # This code might come back in a near future
    #validate :ensure_at_least_one_reward_validation, unless: :is_flexible?
    validate :validate_tags

    def validate_tags
      errors.add(:public_tags, :less_than_or_equal_to, count: 5) if public_tags.size > 5
    end

    def self.get_routes
      @@mapped_routes ||= @@routes.inject(Set.new) do |memo, item|
        memo << $1 if item.path.spec.to_s.match(/^\/([\w]+)\S/)
        memo
      end
    end

    def self.permalink_on_routes?(permalink)
      permalink && self.get_routes.include?(permalink.downcase)
    end

    def permalink_cant_be_route
      errors.add(:permalink, I18n.t("activerecord.errors.models.project.attributes.permalink.invalid")) if Project.permalink_on_routes?(permalink)
    end
    
    def ensure_at_least_one_reward_validation
      errors.add(
        'rewards.size',
        I18n.t("activerecord.errors.models.project.attributes.rewards.at_least_one")
      ) if rewards.empty?
    end
  end
end
