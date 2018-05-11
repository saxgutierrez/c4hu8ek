class Api::V1::PinsController < ApplicationController
  before_action :authenticate!, :only => [:index, :create]   # por recomendación del tutor, la autenticación se hace aquí directamente en el controlador de la API
  #before_action :authenticate_user, :only => [:index, :create] # autenticación solo por usuario
  #before_action :authenticate_token, :only => [:index, :create] #autenticación solo por token
# leer los headers del usuario y el token, buscar en la base de datos con ese usuario es decir con el obtenido en el request y comparar el token del usuario
  #con el toquen que llega con la solicitud o request,  si el usuario no existe, o si existe pero el token es diferente devuelve el error 401
 
def authenticate!
# autenticación con curl -XGET -H "X-User-Email:diegofdog@gmail.com” -H "X-Api-Token: e77aca7aab4f325f064b8c7b288e7414" "http://localhost:3000/api/v1/pins"
email =  request.headers["HTTP_X_USER_EMAIL"] 
token =  request.headers['HTTP_X_API_TOKEN']
user_email = User.find_by_email(email)
user_token =  User.find_by(api_token: token)
if (user_email.email && user_email.api_token == user_token.api_token)
  render json: user_token.api_token
  puts email
  puts token
  else
      render json:{ errors: [ { detail: "Access denied" } ] }, status: 401
    end
end


def authenticate_user
  # autenticación con curl -XGET -H "X-User-Email: diegofdog@gmail.com” "http://localhost:3000/api/v1/pins"
   email =  request.headers["HTTP_X_USER_EMAIL"] 
   user_email = User.find_by_email(email)
    if (user_email)
      render json: user_email #impresiones en rails c
      puts email #impresiones en rails s
      else
      render json:{ errors: [ { detail: "Access denied" } ] }, status: 401
    end
end

def authenticate_token
  # autenticación con curl -XGET -H "X-Api-Token: e77aca7aab4f325f064b8c7b288e7414" "http://localhost:3000/api/v1/pins" 
   token =  request.headers['HTTP_X_API_TOKEN'] 
   user_token =  User.find_by(api_token: token)
    if (user_token)
      render json: user_token #impresiones en rails c
      puts toke #impresiones en rails s
      else
      render json:{ errors: [ { detail: "Access denied" } ] }, status: 401
    end
end

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end