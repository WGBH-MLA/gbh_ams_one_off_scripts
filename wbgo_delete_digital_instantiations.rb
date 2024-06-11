aapb_ids = %w(
  cpb-aacip-c88b33d7358
  cpb-aacip-f1ae8d53434
  cpb-aacip-019e7cac605
  cpb-aacip-f3b09f6678e
  cpb-aacip-80f53d5da69
  cpb-aacip-cc15b90b384
  cpb-aacip-1ff29659b46
  cpb-aacip-482bb33c1bc
  cpb-aacip-c6031b0e935
  cpb-aacip-6ebc10485e7
  cpb-aacip-51648e75603
  cpb-aacip-51c3bba4f79
  cpb-aacip-575a10227a1
  cpb-aacip-2a9f06c0128
  cpb-aacip-9cd2835a6b5
  cpb-aacip-8cb4e400b0c
  cpb-aacip-fb82f5dd309
  cpb-aacip-bef9b6d7456
  cpb-aacip-e8780d9a0a9
  cpb-aacip-7dfc2c698cb
  cpb-aacip-8decc2181c0
  cpb-aacip-1412ec8f88b
  cpb-aacip-d1cf98896c3
  cpb-aacip-485d84c5dc5
  cpb-aacip-e12313137cc
  cpb-aacip-c3ac4f7577a
  cpb-aacip-82ba318c312
  cpb-aacip-a05b2a13b73
  cpb-aacip-e27b5e518b7
  cpb-aacip-ad6d1abfc06
  cpb-aacip-02260da6323
  cpb-aacip-bd0f2156ebb
  cpb-aacip-ec27eb2e293
  cpb-aacip-fae9fbdd91d
  cpb-aacip-3af55f5a09d
  cpb-aacip-015140162e8
  cpb-aacip-223e1efcea9
  cpb-aacip-2f035514157
  cpb-aacip-9c3bdc57501
  cpb-aacip-56dc3735f35
  cpb-aacip-6d008ca547c
  cpb-aacip-0d4f8c17e1c
  cpb-aacip-5a17ba408d8
)

Object.send(:remove_const, :DeleteVideoPhysicalInstantiations) if Object.const_defined?(:DeleteVideoPhysicalInstantiations)
class DeleteVideoPhysicalInstantiations
  attr_reader :aapb_ids, :errors

  def initialize(aapb_ids:)
    @aapb_ids = aapb_ids
    @errors = []
  end

  def delete_video_instantiations!
    asset_resources.each do |ar|
      ar.members.select do |m|
        (m.class == PhysicalInstantiationResource) &&
        (m.media_type.include? "Moving Image")
      end.each do |pi|
        ar.members.delete(pi)
        pi.delete
      end
      ar.save!
      Hyrax
  end

  def asset_resources
    @asset_resources ||= aapb_ids.map do |id|
      AssetResource.find(id)
    rescue => e
      @errors << e
    end.compact
  end

  def asset_resources_with_video
    @asset_resources_with_video ||= asset_resources.select do |ar|
      ar.members.detect do |m|
        (m.class == PhysicalInstantiationResource) &&
        (m.media_type.include? "Moving Image")
      end
    end
  end
end



ddi = DeleteVideoPhysicalInstantiations.new(aapb_ids: aapb_ids.sample(1))
ddi.asset_resources_with_video.count
