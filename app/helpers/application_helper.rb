module ApplicationHelper
  def nav_bar(&block)
    content_tag(:ul, class: 'navbar-nav', &block)
  end

  def nav_link(path, &block)
    options = current_page?(path) ? { class: 'nav-item active' } : { class: 'nav-item' }
    content_tag(:li, options) do
      link_to path, class: 'nav-link', &block
    end
  end

  def user_spaces
    @user_spaces ||= current_user.spaces.order(:name)
  end

  def abbrev_name(name)
    name.blank? ? 'X' : name.split(' ').map(&:first).join('.')
  end

  def vertical_layout?
    Rails.application.config.interface_layout == 'VERTICAL'
  end
end
