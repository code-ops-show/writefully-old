require 'spec_helper'

feature "WritefullySitesFeature" do 
  fixtures :"writefully/sites"
  fixtures :"writefully/posts"
  fixtures :"writefully/authorships"

  let(:owner) { writefully_authorships(:wf_owner_1) }
  let(:site)  { writefully_sites(:codemy_net) }
  let(:post_1) { writefully_posts(:hash_selector_pattern) }

  before do 
    Writefully::ApplicationController.any_instance.stub(:current_wf_authorship).and_return(owner)
    Writefully::Site.any_instance.stub(:processing_errors).and_return([])
  end

  scenario "should see site in index" do 
    visit sites_path
    expect(page).to have_content site.name
  end

  scenario "should redirected and see posts" do 
    visit site_path(site)
    expect(page).to have_content post_1.title
    expect(current_path).to eq site_posts_path(site)
  end
end
