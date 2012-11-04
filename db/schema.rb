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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "areas", :force => true do |t|
    t.string   "url"
    t.string   "area_name",              :limit => 100, :null => false
    t.string   "area_code",              :limit => nil, :null => false
    t.integer  "parent_id"
    t.integer  "source_system_id",                      :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "source_system_area_key", :limit => 20
  end

  create_table "competitions", :force => true do |t|
    t.string   "competition_name",              :limit => 50, :null => false
    t.integer  "source_system_id",                            :null => false
    t.integer  "area_id",                                     :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "source_system_competition_key", :limit => 20
  end

  create_table "events", :force => true do |t|
    t.string   "event_code",              :limit => 10,  :null => false
    t.string   "event_name",              :limit => 50,  :null => false
    t.integer  "minute",                  :limit => 2
    t.integer  "minute_extra",            :limit => 2
    t.integer  "person_id"
    t.integer  "team_id"
    t.integer  "source_system_id",                       :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "source_system_event_key", :limit => 100
  end

  create_table "groups", :force => true do |t|
    t.integer  "round_id"
    t.string   "details",                 :limit => 100
    t.string   "group_name",              :limit => 50,  :null => false
    t.integer  "source_system_id",                       :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "source_system_group_key", :limit => 20
  end

  create_table "matches", :force => true do |t|
    t.datetime "date_time",                                            :null => false
    t.integer  "team_a_id",                                            :null => false
    t.integer  "team_b_id",                                            :null => false
    t.integer  "hts_a",                   :limit => 2,  :default => 0
    t.integer  "hts_b",                   :limit => 2,  :default => 0
    t.integer  "fs_a",                    :limit => 2,  :default => 0
    t.integer  "fs_b",                    :limit => 2,  :default => 0
    t.integer  "ets_a",                   :limit => 2,  :default => 0
    t.integer  "ets_b",                   :limit => 2,  :default => 0
    t.integer  "ps_a",                    :limit => 2,  :default => 0
    t.integer  "ps_b",                    :limit => 2,  :default => 0
    t.integer  "game_week_num",           :limit => 2
    t.string   "status",                  :limit => 10
    t.string   "winner",                  :limit => 1
    t.integer  "group_id"
    t.integer  "round_id"
    t.integer  "source_system_id",                                     :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "source_system_match_key", :limit => 20
  end

  create_table "persons", :force => true do |t|
    t.string   "person_name",              :limit => 100, :null => false
    t.integer  "source_system_id",                        :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "source_system_person_key", :limit => 100
  end

  create_table "rounds", :force => true do |t|
    t.date     "start_date",                            :null => false
    t.date     "end_date",                              :null => false
    t.string   "round_name",              :limit => 50, :null => false
    t.integer  "season_id",                             :null => false
    t.integer  "source_system_id",                      :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "source_system_round_key", :limit => 20
  end

  create_table "seasons", :force => true do |t|
    t.date     "start_date",                             :null => false
    t.date     "end_date",                               :null => false
    t.string   "season_name",              :limit => 50, :null => false
    t.integer  "competition_id",                         :null => false
    t.integer  "source_system_id",                       :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "source_system_season_key", :limit => 20
  end

  create_table "source_systems", :force => true do |t|
    t.string   "source_system_name", :limit => 50,   :null => false
    t.string   "source_system_code", :limit => 10,   :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "url",                :limit => 1024
  end

  create_table "teams", :force => true do |t|
    t.string   "team_name",              :limit => 50, :null => false
    t.string   "url"
    t.integer  "source_system_id",                     :null => false
    t.integer  "area_id",                              :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "source_system_team_key", :limit => 50
  end

end
