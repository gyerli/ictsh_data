class AddCompetitionUrlToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :competition_url, :text
  end
end
