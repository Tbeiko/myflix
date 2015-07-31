shared_examples "require signed in user" do 
  it "redirects to the sign in page" do 
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end