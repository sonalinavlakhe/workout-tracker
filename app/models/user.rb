class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :create_tenant
  after_destroy :delete_tenant
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, request_keys: [:subdomain]

  validates :email, uniqueness: true


  def create_tenant
  	Apartment::Tenant.create(subdomain)
  end

  def delete_tenant
  	Apartment::Tenant.drop(subdomain)
  end

  def self.find_for_authentication(warden_coditions)
  	where(email: warden_coditions[:email], subdomain: warden_coditions[:subdomain]).first

  end
end
