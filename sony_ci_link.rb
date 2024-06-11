class SonyCiLinker
    attr_reader :asset_ids
    
    def initialize(asset_ids:)
        @asset_ids = asset_ids
    end

    def link!
        assets.each do |asset|
            asset.admin_data.sony
        end
    end

end