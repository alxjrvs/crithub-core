class CharactersController < ApplicationController
  def new
    @character = Character.create
    redirect_to edit_character_path(@character, step: "race")
  end

  def edit
    @character = Character.find(params[:id])
    @character.levels.build
    @character.mods.build
    @step = params[:step]
  end

  def update
    @character = Character.find(params[:id])
    @character.update_attributes(character_params)
    if next_step == "foo"
      byebug
    end
    redirect_to edit_character_path(@character, step: next_step)
  end

  private

  def character_params
    params.require(:character).permit(
      :race, 
      levels_attributes: [ :class_name, :number ],
      mods_attributes: [ :source, :modifier, :value ]
    )
  end

  def next_step
    params[:step] || params[:character][:next_step]
  end
end
