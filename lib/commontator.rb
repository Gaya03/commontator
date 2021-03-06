require 'commontator/engine'
require 'commontator/controller_includes'

module Commontator
  # Attributes

  # Can be set in initializer only
  ENGINE_ATTRIBUTES = [
    :current_user_proc,
    :javascript_proc
  ]

  # Can be set in initializer or passed as an option to acts_as_commontator
  COMMONTATOR_ATTRIBUTES = [
    :user_name_proc,
    :user_avatar_proc,
    :user_email_proc,
    :user_link_proc
  ]
  
  # Can be set in initializer or passed as an option to acts_as_commontable
  COMMONTABLE_ATTRIBUTES = [
    :email_from_proc,
    :thread_read_proc,
    :thread_moderator_proc,
    :thread_subscription,
    :comment_voting,
    :voting_text_proc,
    :comment_order,
    :comments_per_page,
    :wp_link_renderer_proc,
    :comment_editing,
    :comment_deletion,
    :moderators_can_edit_comments,
    :hide_deleted_comments,
    :hide_closed_threads,
    :commontable_name_proc,
    :commontable_url_proc
  ]
  
  DEPRECATED_ATTRIBUTES = [
    [:user_name_clickable, :user_link_proc],
    [:user_admin_proc, :thread_moderator_proc],
    [:auto_subscribe_on_comment, :thread_subscription],
    [:can_edit_own_comments, :comment_editing],
    [:can_edit_old_comments, :comment_editing],
    [:can_delete_own_comments, :comment_deletion],
    [:can_delete_old_comments, :comment_deletion],
    [:can_subscribe_to_thread, :thread_subscription],
    [:can_vote_on_comments, :comment_voting],
    [:combine_upvotes_and_downvotes, :voting_text_proc],
    [:comments_order, :comment_order],
    [:closed_threads_are_readable, :hide_closed_threads],
    [:deleted_comments_are_visible, :hide_deleted_comments],
    [:can_read_thread_proc, :thread_read_proc],
    [:can_edit_thread_proc, :thread_moderator_proc],
    [:admin_can_edit_comments, :moderators_can_edit_comments],
    [:subscription_email_enable_proc, :user_email_proc],
    [:comment_name, 'config/locales'],
    [:comment_create_verb_present, 'config/locales'],
    [:comment_create_verb_past, 'config/locales'],
    [:comment_edit_verb_present, 'config/locales'],
    [:comment_edit_verb_past, 'config/locales'],
    [:timestamp_format, 'config/locales'],
    [:subscription_email_to_proc, 'config/locales'],
    [:subscription_email_from_proc, :email_from_proc],
    [:subscription_email_subject_proc, 'config/locales'],
    [:current_user_method, :current_user_proc],
    [:user_missing_name, 'config/locales'],
    [:user_email_method, :user_email_proc],
    [:user_name_method, :user_name_proc],
    [:commontable_name, :commontable_name_proc],
    [:commontable_id_method]
  ]
  
  (ENGINE_ATTRIBUTES + COMMONTATOR_ATTRIBUTES + \
    COMMONTABLE_ATTRIBUTES).each do |attribute|
    mattr_accessor attribute
  end

  DEPRECATED_ATTRIBUTES.each do |deprecated, replacement|
    define_singleton_method(deprecated) do
      @deprecated_method_called = true
      replacement_string = (replacement.nil? ? 'No replacement is available. You can safely remove it from your configuration file.' : "Use `#{replacement.to_s}` instead.")
      warn "\n[COMMONTATOR] Deprecation: `config.#{deprecated.to_s}` is deprecated and has been disabled. #{replacement_string}\n"
    end

    define_singleton_method("#{deprecated.to_s}=") do |obj|
      send(deprecated)
    end
  end
  
  def self.configure
    @deprecated_method_called = false
    yield self
    warn "\n[COMMONTATOR] We recommend that you backup the config/initializers/commontator.rb file, rename or remove it, run rake commontator:install:initializers to copy the new default one, then configure it to your liking.\n" if @deprecated_method_called
  end
end

require 'commontator/acts_as_commontator'
require 'commontator/acts_as_commontable'