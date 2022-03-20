Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      # 'line_foods/replace'というURLに対してPUTリクエストがきたら
      # line_foods_controller.rbのreplaceメソッドを呼ぶ
      put 'line_foods/replace', to: 'line_foods#replace'
      resources :orders, only: %i[create]
    end
  end
end
