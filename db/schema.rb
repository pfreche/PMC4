# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system. Peter 7.12. 

ActiveRecord::Schema.define(version: 20130825083917) do
 
  create_table "agroups", force: true do |t|
    t.string "name"
  end

  create_table "agroups_mfiles", id: false, force: true do |t|
    t.integer "mfile_id"
    t.integer "agroup_id"
  end

  add_index "agroups_mfiles", ["agroup_id"], name: "index_agroups_mfiles_on_agroup_id", using: :btree
  add_index "agroups_mfiles", ["mfile_id"], name: "index_agroups_mfiles_on_mfile_id", using: :btree

  create_table "attris", force: true do |t|
    t.string  "name"
    t.integer "agroup_id"
    t.integer "id_sort"
    t.integer "parent_id"
    t.string  "keycode"
  end

  add_index "attris", ["agroup_id"], name: "index_attris_on_agroup_id", using: :btree
  add_index "attris", ["keycode"], name: "index_attris_on_keycode", using: :btree

  create_table "attris_mfiles", id: false, force: true do |t|
    t.integer "mfile_id"
    t.integer "attri_id"
  end

  add_index "attris_mfiles", ["attri_id"], name: "index_attris_mfiles_on_attri_id", using: :btree
  add_index "attris_mfiles", ["mfile_id"], name: "index_attris_mfiles_on_mfile_id", using: :btree

  create_table "folders", force: true do |t|
    t.integer "storage_id"
    t.string  "mpath"
    t.string  "lfolder"
    t.integer "mfile_id"
  end

  add_index "folders", ["storage_id"], name: "index_folders_on_storage_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "uri"
    t.string   "description"
    t.integer  "typ"
    t.integer  "storage_id"
    t.boolean  "inuse"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mfiles", force: true do |t|
    t.integer  "folder_id"
    t.string   "filename"
    t.datetime "modified"
    t.date     "mod_date"
  end

  add_index "mfiles", ["folder_id"], name: "index_mfiles_on_folder_id", using: :btree
  add_index "mfiles", ["modified"], name: "index_mfiles_on_modified", using: :btree

  create_table "packlocations", force: true do |t|
    t.string "name"
    t.string "filepath"
    t.string "webpath"
    t.string "tnfilepath"
    t.string "tnwebpath"
  end

  create_table "packs", force: true do |t|
    t.string  "name"
    t.integer "packlocation_id"
  end

  create_table "props", force: true do |t|
    t.integer "mfile_id"
    t.integer "width"
    t.integer "height"
    t.integer "pixels"
    t.integer "size"
    t.string  "md5"
  end

  add_index "props", ["md5"], name: "index_props_on_md5", using: :btree
  add_index "props", ["mfile_id"], name: "index_props_on_mfile_id", using: :btree

  create_table "selections", force: true do |t|
    t.string   "name"
    t.string   "what",       limit: 1
    t.integer  "seize"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "par"
  end

  create_table "selitems", force: true do |t|
    t.integer "objid"
    t.integer "next_id"
    t.integer "prev_id"
    t.integer "selection_id"
    t.string  "what",         limit: 1
  end

  add_index "selitems", ["selection_id"], name: "index_selitems_on_selection_id", using: :btree

  create_table "storages", force: true do |t|
    t.string  "name",        limit: 20
    t.integer "no",                      default: 1
    t.string  "filepath",    limit: 100
    t.string  "webpath",     limit: 50
    t.string  "filepath_tn", limit: 100
    t.string  "webpath_tn",  limit: 50
  end

end
