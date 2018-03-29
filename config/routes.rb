Rails.application.routes.draw do
    resources :games

    resources :players

    resources :game_players

    resources :rounds
end
