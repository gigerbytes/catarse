class UserPolicy < ApplicationPolicy
  def destroy?
    done_by_owner_or_admin?
  end

  def credits?
    done_by_owner_or_admin?
  end

  def redirect_to_user_billing?
    done_by_owner_or_admin?
  end

  def settings?
    done_by_owner_or_admin?
  end

  def billing?
    done_by_owner_or_admin?
  end

  def edit?
    done_by_owner_or_admin?
  end

  def update?
    done_by_owner_or_admin?
  end

  def update_reminders?
    done_by_owner_or_admin?
  end

  def unsubscribe_notifications?
    done_by_owner_or_admin?
  end

  def new_password?
    done_by_owner_or_admin?
  end

  def credit_cards?
    done_by_owner_or_admin?
  end

  def permitted_attributes
    return [] unless user
    u_attrs = [:account_type, :state_inscription, :birth_date, :confirmed_email_at, :public_name, :current_password, :password, :owner_document, :address_street, :subscribed_to_new_followers, :subscribed_to_project_post, :subscribed_to_friends_contributions, bank_account_attributes: [:id, :input_bank_number, :bank_id, :name, :agency, :account, :owner_name, :owner_document, :account_digit, :agency_digit, :account_type]]
    u_attrs << { category_follower_ids: [] }
    if record.kind_of?(User)
      u_attrs << record.attribute_names.map(&:to_sym) 
    end
    u_attrs << { links_attributes: [:id, :_destroy, :link] }
    u_attrs << { category_followers_attributes: [:id, :user_id, :category_id] }
    u_attrs.flatten!

    unless user.try(:admin?)
      u_attrs.delete(:zero_credits)
      u_attrs.delete(:permalink)
      u_attrs.delete(:whitelisted_at)

      if (user.published_projects.present? || user.contributed_projects.present?) && user.public_name.present?
        u_attrs.delete(:public_name)
      end

      if user.name.present? && user.cpf.present?
        u_attrs.delete(:name)
        u_attrs.delete(:cpf)
      end
    end

    u_attrs.flatten
  end

  protected
  def done_by_owner_or_admin?
    record == user || user.try(:admin?)
  end
end

