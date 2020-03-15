json.extract! notice, :id, :title, :text, :mfile_id, :created_at, :updated_at
json.url notice_url(notice, format: :json)