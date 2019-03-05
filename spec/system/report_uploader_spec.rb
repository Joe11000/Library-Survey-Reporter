require 'rails_helper'

RSpec.describe "ReportUploaders", type: :system do
  
  def get_single_record 
    FileParser::JSONParser.call( Rails.root.join( 'spec', 'shared', 'json_files', 'single_record_upload.json' ) )
  end

  def get_multiple_records 
    FileParser::JSONParser.call( Rails.root.join( 'spec', 'shared', 'json_files', 'multi_record_upload.json' ) )
  end

  def tests_for_single_record 
    expect(page).to have_content "Total Pages Read: 1"
    expect(page).to have_css(".dewey_decimal_category", count: 1)
  end

  def tests_for_multiple_records

  end

  def fill_out_record_form records_arr
    fieldsets = page.find("#manual_record_creation_form").all('fieldset')
    
    records_arr.each_with_index do |record, index|
      if index > 0 # add more fields for another record
        find('#add_record_button]').click 
      end
      # byebug

      fieldsets[index].find("#record_title").fill_in with: record['title']
      fieldsets[index].find("#record_author").fill_in with: record['author']
      fieldsets[index].find("#record_pages").fill_in with: record['pages'].to_i
      fieldsets[index].find("#record_dewey_decimal_code").fill_in with: record['dewey_decimal_code']
      fieldsets[index].find("#record_book_read_status").select record['book_read_status']
    end
  end

  context 'A user can' do
    context 'fill out the reports form with' do 
      it 'a single record and see the correct results', js: true do 
        visit root_path

        fill_out_record_form( get_single_record )

        click_button('submit')

        tests_for_single_record
      end

      it 'multiple records and see the correct results', js: true do 
        visit root_path

        fill_out_record_form([ get_multiple_records ])

        click_button('submit')

        tests_for_multiple_records
      end
    end
  end

  context 'file upload form submission' do 
    context 'csv file' do 
      context 'with a single record' do 
        it 'tests_for_single_record' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records', Rails.root.join( 'spec', 'shared', 'csv_files', 'single_record_upload.csv' )
          end

          click_button('submit')
  
          tests_for_single_record
        end
      end
      context 'with multiple records' do 
        it 'tests_for_multi_record' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records', Rails.root.join( 'spec', 'shared', 'csv_files', 'multi_record_upload.csv' )
          end

          click_button('submit')

          tests_for_multiple_records
        end
      end
    end
    context 'json file' do 
      context 'with a single record' do 
        it 'tests_for_single_record' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records',  Rails.root.join( 'spec', 'shared', 'json_files', 'single_record_upload.json' )
          end

          click_button('submit')
  
          tests_for_single_record
        end
      end
      context 'with multiple records' do 
        it 'tests_for_multiple_records' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records', Rails.root.join( 'spec', 'shared', 'json_files', 'multi_record_upload.json' )
          end

          click_button('submit')

          tests_for_multiple_records
        end
      end
    end

    context 'xml file' do 
      context 'with a single record' do 
        it 'tests_for_single_record' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records', Rails.root.join( 'spec', 'shared', 'xml_files', 'single_record_upload.xml' )
          end

          click_button('submit')
  
          tests_for_single_record
        end
      end
      context 'with multiple records' do 
        it 'tests_for_multiple_records' do 
          visit root_path

          within '#file_upload_creation_form' do 
            attach_file 'Records', Rails.root.join( 'spec', 'shared', 'xml_files', 'multi_record_upload.xml' )
          end

          click_button('submit')

          tests_for_multiple_records
        end
      end
    end
  end



  context 'testing js on screen' do 
    it 'can\'t remove record if only one exist', js: true  do 
      visit root_path

      expect(page.find("#manual_record_creation_form")).to have_css('fieldset', count: 1)      

      click_button 'delete'
      expect(page.find("#manual_record_creation_form")).to have_css('fieldset', count: 1)      
    end

    it 'can remove a record from the if multiple exist', js: true  do 
      visit root_path

      find('#add_record_button]').click
      expect(page.find("#manual_record_creation_form")).to have_css('fieldset', count: 2)
      
      fieldsets = page.find_all('fieldset')
      within fieldsets[1] do 
        fill_in 'record_title', with: "title1"
      end
      within fieldsets[0] do 
        fill_in 'record_title', with: "title0"
        click_button 'delete'
      end

      expect(page).to have_css('fieldset', count: 1)
      expect(page).to have_field 'record_title', with: "title1"
      expect(page).to have_no_field 'record_title', with: "title0"
    end
    
    it 'can add a record from the form', js: true do 
      visit root_path
      expect(page.find("#manual_record_creation_form")).to have_css('fieldset', count: 1)      
      find('#add_record_button]').click
      expect(page.find("#manual_record_creation_form")).to have_css('fieldset', count: 2)      
    end
  end
end
