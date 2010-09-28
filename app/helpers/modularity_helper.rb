module ModularityHelper
  # Renders hooks defined in Dashboard plugins. Hooks sit in each plugin's
  # app/views/hooks directory where the partial name matches the hook name by
  # the Rails partial naming convention of prefixing the partial name with an
  # underscore.
  #
  # Example:
  #
  #     render_hooks :global_nav
  #
  # This will render each _gobal_nav partial, for instance your plugin's
  # app/views/hooks/_global_nav.haml
  #
  # TODO: Determine ordering determinacy
  #
  def render_hooks(name)
    templates = find_templates("hooks/_#{name}").map{|t| t.render self}.join
  end

  private

  def find_templates(original_template_path)
    template_path = original_template_path.to_s.sub(/^\//, '')
    templates = []

    view_paths.each do |load_path|
      if template = load_path["#{template_path}.#{I18n.locale}"]
        templates << template
      elsif template = load_path["#{template_path}.#{I18n.default_locale}"]
        templates << template
      elsif template = load_path[template_path]
        templates << template
      end
    end

    templates
  end
end
