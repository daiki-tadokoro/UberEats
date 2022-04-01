module Api
  module V1
    class LineFoodsController < ApplicationController
      #create, replaceの前にはset_foodを行う
      before_action :set_food, only: %i[create replace]

      def index
        # activeなもの取得して、line_foodsに代入
        line_foods = LineFood.active
        # line_foodsが空かどうか？
        # .exists?メソッドは対象のインスタンスのデータがDBに存在するかどうか？を
        # true/falseで返す
        if line_foods.exists?
          # render json: {
          #   # Rubyの.mapメソッドは配列やハッシュオブジェクトなどを１つずつとりだし
          #   # .mapより後ろのブロック(ここでは{ |line_food| line_food.id }の部分)をあてる
          #   line_food_ids: line_foods.map { |line_food| line_food.id },
          #   # １つの仮注文につき１つの店舗という仕様のため
          #   # line_foodsの中にある先頭のline_foodインスタンスの店舗の情報を詰めている
          #   restaurant: line_foods[0].restaurant,
          #   count: line_foods.sum { |line_food| line_food[:count] },
          #   amount: line_foods.sum { |line_food| line_food.total_amount },
          # }, status: :ok
          line_food_ids = []
          count = 0
          amount = 0

          line_foods.each do line_foodl
            line_food_ids << line_food.id #(1) idを参照して配列を追加する
            count += line_food[:count] #(2) countのデータを合算する
            amount += line_food.total_amount #(3) total_amountを合算する
          end

          render json: {
            line_food_ids: line_food_ids,
            restaurant: line_foods[0].restaurant,
            count: count,
            amount: amount,
          }, status: ok
        else
          render json: {}, status: :no_content
        end
      end
      
      # 仮注文の作成
      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable
        end
        
        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      def replace
        # mapは配列を返すがeachは処理を行うだけ
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          # line_food.activeをfalseにする
          line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
        }, status: :created
        else
          render json {}, status: :internal_server_error
        end
      end

      private
      
      # before_action
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        # すでに同じfoodに関するline_foodが存在するか
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          # line_foodインスタンスの既存の情報を更新
          # ここでは、countとactiveの２つを更新
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          # 新しくline_foodを生成
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end
