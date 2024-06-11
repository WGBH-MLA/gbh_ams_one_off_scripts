@error = nil
@client = SonyCiApi::Client.new('config/ci.yml')

@guids = %w(
  cpb-aacip-75-84zgn33s
  cpb-aacip-75-418kq3hj
  cpb-aacip-75-72p5j4xx
  cpb-aacip-75-30prrg9s
  cpb-aacip-75-87brvgkp
  cpb-aacip-516-n00zp3wz82
  cpb-aacip-516-nz80k27h0k
  cpb-aacip-516-d795718n8k
  cpb-aacip-516-b27pn8z89n
  cpb-aacip-516-251fj2b564
  cpb-aacip-516-6m3319sz98
  cpb-aacip-516-vx05x26k9d
  cpb-aacip-516-q52f76788w
  cpb-aacip-516-5x2599zx9b
  cpb-aacip-516-sb3ws8jm42
  cpb-aacip-512-n58cf9k68p
  cpb-aacip-516-kd1qf8kh53
  cpb-aacip-516-r20rr1qp52
  cpb-aacip-516-2v2c825722
  cpb-aacip-394-24jm68wc
  cpb-aacip-512-kk94747s65
  cpb-aacip-75-65v6x5qp
  cpb-aacip-825984c5fa3
  cpb-aacip-901dfeea4db
  cpb-aacip-dd10f8471b1
  cpb-aacip-302a0ce217c
  cpb-aacip-d12a72cd84b
  cpb-aacip-90a793b526e
  cpb-aacip-64c35aa98cb
  cpb-aacip-3b919964310
  cpb-aacip-c017491aa50
  cpb-aacip-e4bce867bd6
  cpb-aacip-3fc094d0476
  cpb-aacip-a5795db349f
  cpb-aacip-55f35238947
  cpb-aacip-4f036fc316b
  cpb-aacip-2b4a5275f9c
  cpb-aacip-fcac4a602e6
  cpb-aacip-269eeb78e89
  cpb-aacip-0e3ddebe800
  cpb-aacip-6e9ccb7f4f8
  cpb-aacip-085b67be517
  cpb-aacip-bd42537cc80
  cpb-aacip-cd5ab3baa10
  cpb-aacip-0515ac167c0
  cpb-aacip-f8203a11f2d
  cpb-aacip-c639ccc7d84
  cpb-aacip-978d218512d
  cpb-aacip-1f448e18360
  cpb-aacip-8e97ebbe3f9
  cpb-aacip-61992d38519
  cpb-aacip-a042cea6411
)


@found_records = {}
@errors = {}

@guids.each do |guid|
  begin
    search_str = guid[-20..-1]
    sony_ci_records = @client.workspace_search(search_str)
    @found_records[guid] = sony_ci_records.detect do |sony_ci_record|
      sony_ci_record['name'] =~ /^#{guid}/
    end
  rescue => e
    @errors[guid] = e
  end
end

@sony_ci_ids = @found_records.map { |r| r['id'] }

@params = {
  "name": "NJN Network Assets for Kelley",
  "assetIds": @found_records.keys,
  "type": "Secure",
  "allowSourceDownload": true,
  "allowPreviewDownload": true,
  "allowElementDownload": true,
  "recipients": [
    "kelleylynch@gmail.com>"
  ],
  "message": "here are your files, Kelley",
  "password": "NJNfiles",
  "expirationDays": 30,
  "sendNotifications": false,
  "notifyOnOpen": false,
  "notifyOnChange": false,
  "filters": {
    "elements": {
      "types": [
        "Video"
      ]
    }
  }
}

# begin
#   @client.post '/mediaboxes', params: @params
# rescue => e
#   @error = e
# end
