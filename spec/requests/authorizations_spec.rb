require 'spec_helper'
include LoginHelper

feature 'view scene listing page' do
  let(:user) { Factory.create(:user) }
  let(:project) { Factory.create(:project) }

  context 'anon user' do
    context 'visiting projects/scenes nested route' do
      scenario 'able to view scenes' do
        visit "/projects/#{project.id}/scenes"

        page.should have_content "Listing scenes"
      end
    end

    context 'visiting /scenes page' do
      scenario 'not allowed to view scenes' do
        visit '/scenes'

        within '.alert' do
          page.should have_content 'Not authorized!'
        end
      end
    end
  end

end
