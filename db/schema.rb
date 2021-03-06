# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180508191244) do

  create_table "agroups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "agroups_mfiles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "mfile_id"
    t.integer "agroup_id"
    t.index ["agroup_id"], name: "index_agroups_mfiles_on_agroup_id", using: :btree
    t.index ["mfile_id"], name: "index_agroups_mfiles_on_mfile_id", using: :btree
  end

  create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "artist_id",             null: false
    t.string   "name",                  null: false
    t.datetime "date_added",            null: false
    t.string   "year",       limit: 20
    t.index ["artist_id", "name"], name: "artist_id", unique: true, using: :btree
  end

  create_table "artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        null: false
    t.datetime "date_added",  null: false
    t.string   "browse_name"
    t.index ["name"], name: "name", unique: true, using: :btree
  end

  create_table "attris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "agroup_id"
    t.integer "id_sort"
    t.integer "parent_id"
    t.string  "keycode"
    t.index ["agroup_id"], name: "index_attris_on_agroup_id", using: :btree
    t.index ["keycode"], name: "index_attris_on_keycode", using: :btree
  end

  create_table "attris_mfiles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "mfile_id"
    t.integer "attri_id"
    t.index ["attri_id"], name: "index_attris_mfiles_on_attri_id", using: :btree
    t.index ["mfile_id"], name: "index_attris_mfiles_on_mfile_id", using: :btree
  end

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "folder_id"
    t.integer  "mfile_id"
  end

  create_table "collection", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "path", limit: 500, null: false
  end

  create_table "folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "storage_id"
    t.string  "mpath"
    t.string  "lfolder"
    t.integer "mfile_id"
    t.string  "title"
    t.index ["storage_id"], name: "index_folders_on_storage_id", using: :btree
  end

  create_table "indexer", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "last_modified", null: false
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "uri"
    t.string   "description"
    t.integer  "typ"
    t.integer  "storage_id"
    t.boolean  "inuse"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix"
    t.integer  "mfile_id"
    t.boolean  "origin"
  end

  create_table "matches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "pattern"
    t.string   "extract"
    t.string   "tag"
    t.string   "filter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "result"
  end

  create_table "media_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mfiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "folder_id"
    t.string   "filename"
    t.datetime "modified"
    t.date     "mod_date"
    t.integer  "mtype"
    t.index ["folder_id"], name: "index_mfiles_on_folder_id", using: :btree
    t.index ["modified"], name: "index_mfiles_on_modified", using: :btree
  end

  create_table "mtypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "model"
    t.boolean  "has_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "text",       limit: 65535
    t.integer  "mfile_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "packlocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "filepath"
    t.string "webpath"
    t.string "tnfilepath"
    t.string "tnwebpath"
  end

  create_table "packs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "packlocation_id"
  end

  create_table "play_log", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "track_id"
    t.datetime "date_played",                 null: false
    t.integer  "user_id"
    t.boolean  "scrobbled",   default: false, null: false
    t.index ["track_id"], name: "ix_play_log_track_id", using: :btree
  end

  create_table "playlist_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "playlist_id"
    t.integer "track_id"
  end

  create_table "playlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          null: false
    t.datetime "date_created",  null: false
    t.datetime "date_modified", null: false
    t.integer  "user_id"
    t.index ["name"], name: "name", unique: true, using: :btree
  end

  create_table "properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",  limit: 100, null: false
    t.string "value",             null: false
    t.index ["name"], name: "name", unique: true, using: :btree
  end

  create_table "props", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "mfile_id"
    t.integer "width"
    t.integer "height"
    t.integer "pixels"
    t.integer "size"
    t.string  "md5"
    t.index ["md5"], name: "index_props_on_md5", using: :btree
    t.index ["mfile_id"], name: "index_props_on_mfile_id", using: :btree
  end

  create_table "request_log", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "ip_address",      limit: 16, null: false
    t.datetime "date_of_request",            null: false
    t.string   "request_url",                null: false
    t.string   "user_agent",                 null: false
    t.string   "referer",                    null: false
    t.string   "cookies",                    null: false
  end

  create_table "scanners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "tag"
    t.string   "pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "match"
    t.string   "url"
    t.string   "attr"
    t.string   "final"
    t.string   "stype"
  end

  create_table "selections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "what",       limit: 1
    t.integer  "seize"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "par"
  end

  create_table "selitems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "objid"
    t.integer "next_id"
    t.integer "prev_id"
    t.integer "selection_id"
    t.string  "what",         limit: 1
    t.index ["selection_id"], name: "index_selitems_on_selection_id", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",         limit: 10, null: false
    t.integer  "user_id",                 null: false
    t.datetime "date_created",            null: false
  end

  create_table "storages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",        limit: 20
    t.integer "no",                      default: 1
    t.string  "filepath",    limit: 100
    t.string  "webpath",     limit: 50
    t.string  "filepath_tn", limit: 100
    t.string  "webpath_tn",  limit: 50
    t.integer "mtype"
  end

  create_table "tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "artist_id",                 null: false
    t.integer  "album_id"
    t.string   "name",                      null: false
    t.string   "path",          limit: 500, null: false
    t.integer  "length",                    null: false
    t.datetime "date_added",                null: false
    t.integer  "collection_id",             null: false
    t.integer  "track_no",      limit: 2
    t.index ["artist_id", "album_id", "name"], name: "artist_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         limit: 50,                 null: false
    t.string   "pass",         limit: 32,                 null: false
    t.string   "email",                                   null: false
    t.datetime "date_created",                            null: false
    t.boolean  "is_admin",                default: false, null: false
    t.string   "is_active",    limit: 1,  default: "1",   null: false
    t.index ["name"], name: "name", unique: true, using: :btree
  end

end
