# WARNING - DO NOT RUN WHOLE SCRIPT AS-IS.
# The various chunks do various things and I didn't take the time to put it all into
# methods or objects. Just make sure you know what you're doing before doing it.

# For use in an AMS2 Rails console, as of 2023-12-18
# Deletes instantiations with invalid media type "Audio" and resaves the parent Assets.
# NOTE: lines ending with "; nil" are to suppress console output.
def set_physical_instantiation_media_type_from_asset(asset_id:, media_type:)
  puts "Setting Physical Instantiation Media Type to #{media_type} for Asset #{asset_id}...."
  valid_media_types = ["Sound", "Moving Image"]
  raise ArgumentError, "media_type must be one of #{valid_media_types.join(', ')}" unless valid_media_types.include? media_type
  asset = Asset.find(asset_id)
  asset.members.select{|m| m.class == PhysicalInstantiation}.each do |inst|
    inst.media_type = media_type
    inst.save!
  end
  asset.save!
  puts "Fixed #{asset.id}"
rescue => e
  puts "#{e.class} - #{e.message}"
end




def set_physical_instantiation_media_type_from_asset(asset_id:, media_type:)
  puts "Setting Physical Instantiation Media Type to #{media_type} for Asset #{asset_id}...."
  valid_media_types = ["Sound", "Moving Image"]
  raise ArgumentError, "media_type must be one of #{valid_media_types.join(', ')}" unless valid_media_types.include? media_type
  asset = AssetResource.find(asset_id)
  asset.members.select{|m| m.class == PhysicalInstantiationResource}.each do |inst|
    inst.media_type = media_type
    inst.save!
  end
  asset.save!
  puts "Fixed #{asset.id}"
rescue => e
  puts "#{e.class} - #{e.message}"
end





@solr = Blacklight.default_index.connection
@asset_docs_with_media_type_audio = @solr.select(params: { q: "media_type_ssim:Audio", rows: 999999})['response']['docs']; nil
@asset_docs_with_media_type_audio.count
@asset_docs_with_media_type_audio_only = @asset_docs_with_media_type_audio.select { |doc| doc['media_type_ssim'] == ["Audio"] }; nil



# Check holding organizations to verify that they are WIPR.
# NOTE: on production, found that all but 34 were had WIPR listed as at least one of the holding orgs.
@holding_orgs = {}
@asset_docs_with_media_type_audio.each do |doc|
    doc['holding_organization_ssim'].each do |holding_org|
        @holding_orgs[holding_org] = @holding_orgs[holding_org].to_i + 1
    end
end; nil


# Count how many Assets for every group of holding org that includes WIPR.
@holding_org_groups = {}
@asset_docs_with_media_type_audio.each do |doc|
    @holding_org_groups[doc['holding_organization_ssim']] = @holding_org_groups[doc['holding_organization_ssim']].to_i + 1
end; nil

# Count how many Assets for every group of holding org that does not include WIPR.
@not_wipr_assets = @asset_docs_with_media_type_audio.select { |doc| doc['holding_organization_ssim'].include? "WIPR" == false }; nil



@wipr_assets = @solr.select(params: { q: "holding_organization_sim:WIPR", rows: 999999})['response']['docs']; nil


solr = Blacklight.default_index.connection
asset_docs = solr.select(params: { q: "media_type_ssim:Audio", rows: 999999})['response']['docs']; nil
puts "Found #{asset_docs.count} Assets with media_type_ssim:Audio."
asset_docs.each_with_index do |asset_doc, i|
  puts "Fixing asset #{asset_doc['id']}, record #{i+1} of #{asset_docs.count}..."
  asset_resource = AssetResource.find(asset_doc['id'])
  asset_resource.members.select do |m|
    m.try(:media_type) == "Audio"
  end.each do |inst|
    inst.media_type = "Sound"
    inst.save!
  end
  puts "Fixed."
rescue => e
  puts "Error #{e.class}: #{e.message}"
end



wipr_assets_no_sony_ci = wipr_assets.select do |a|
  !a.fetch('sonyci_id_ssim', nil)
end.map{|a| a['id']}; nil