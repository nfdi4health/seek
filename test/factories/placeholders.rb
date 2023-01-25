# Placeholder
Factory.define(:placeholder) do |f|
  f.with_project_contributor
  f.sequence(:title) { |n| "A Placeholder #{n}" }
end

Factory.define(:public_placeholder, parent: :placeholder) do |f|
  f.policy { Factory(:downloadable_public_policy) }
end

Factory.define(:private_placeholder, parent: :placeholder) do |f|
  f.policy { Factory(:private_policy) }
end

Factory.define(:min_placeholder, class: Placeholder) do |f|
  f.with_project_contributor
  f.title 'A Minimal Placeholder'
  f.policy { Factory(:downloadable_public_policy) }
end

Factory.define(:max_placeholder, class: Placeholder) do |f|
  f.with_project_contributor
  f.title 'A Maximal Placeholder'
  f.description 'The Maximal Placeholder'
  f.policy { Factory(:downloadable_public_policy) }
  f.assays { [Factory(:public_assay)] }
  f.other_creators 'Blogs, Joe'
  f.assets_creators { [AssetsCreator.new(affiliation: 'University of Somewhere', creator: Factory(:person, first_name: 'Some', last_name: 'One'))] }
end
