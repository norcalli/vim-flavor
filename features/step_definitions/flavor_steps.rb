Given /^a repository '(.+)' with versions '(.+)'$/ do |basename, versions|
  repository_path = make_repo_path(basename)
  variable_table["#{basename}_uri"] = make_repo_uri(basename)
  system <<-"END"
    {
      mkdir -p '#{repository_path}' &&
      cd '#{repository_path}' &&
      git init &&
      mkdir doc &&
      for v in #{versions}
      do
        echo "*#{basename}* $v" >'doc/#{basename}.txt'
        git add doc
        git commit -m "Version $v"
        git tag -m "Version $v" "$v"
      done
    } >/dev/null
  END
end

Given /^I disable network to the original repository of '(.+)'$/ do |basename|
  delete_path make_repo_path(basename)
end

Then /^I get flavor '(.+)' with '(.+)' in '(.+)'$/ do |basename, version, virtual_path|
  repo_name = make_repo_uri(basename)
  flavor_path = make_flavor_path(expand(virtual_path), repo_name)
  File.open("#{flavor_path}/doc/#{basename}.txt", 'r').read().should ==
    "*#{basename}* #{version}\n"
end

Then /^I don't have flavor '(.+)' in '(.+)'$/ do |basename, virtual_path|
  repo_name = make_repo_uri(basename)
  flavor_path = make_flavor_path(expand(virtual_path), repo_name)
  Dir.should_not exist(flavor_path)
end
