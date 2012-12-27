SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.active_leaf_class = 'active-leaf'
  navigation.items do |primary|
    primary.dom_class = 'nav nav-pills'
    primary.dom_id = 'nav-pills'
    primary.item :archives, 'Archives', '/archives'
    primary.item :tags, 'Tags', '/tags'
    primary.item :about, 'About', '/about'
  end
end
