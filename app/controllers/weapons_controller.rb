class WeaponsController < ApplicationController
  def index
    @weapons = Weapon.all
  end

  def show
    @weapon = Weapon.find(params[:id])
  end

  def create
    @weapon = Weapon.create(weapon_params)
    redirect_to weapons_path
  end

  def destroy
    @weapon = Weapon.find(params[:id])
    @weapon.destroy
    redirect_to weapons_path
  end

  private

  def weapon_params
    params.require(:weapon).permit(:name, :description, :power_step, :power_base, :level)
  end
end
