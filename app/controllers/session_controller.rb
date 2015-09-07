class SessionController < ApplicationController

    

  def create
    user = find_user params[:username],params[:password]
    if user and user.valid_password?(params[:password])
      user.ensure_authentication_token!  # make sure the user has a token generated  
      sign_in user if user   
      render :template=>"sessions/create.json.jbuilder", :status=> :ok, locals: {user: user} , :formats => [:json]
    else
      invalid_login_attempt
    end
  end

  def destroy

    if student_signed_in?
      user = Student.where(:authentication_token => params[:auth_token]).first
    elsif instructor_signed_in?
      user = Instructor.where(:authentication_token => params[:auth_token]).first
    elsif admin_signed_in?
      user = Admin.where(:authentication_token => params[:auth_token]).first
    else
      render :template=>"sessions/delete.json.jbuilder", :success => false, :status=> :ok,
        locals: {message: "Sign out failed"} ,:formats => [:json]
    end
      user.reset_authentication_token!
      render :template=>"sessions/delete.json.jbuilder", :status=> :ok,
        locals: {message: "Good Bye"} ,:formats => [:json]
  end

  private
    def find_user (username,password)
      if user = User.find_by_email(username) and student.valid_password?(password)
         user = User.find_for_database_authentication(:username => username)
      end     
        user
    end

    def invalid_login_attempt
     warden.custom_failure!
     render :template=>"sessions/error.json.jbuilder",locals:{message: "Invalid"},
     :success => true, :status => :ok ,:formats => [:json]
    end
end