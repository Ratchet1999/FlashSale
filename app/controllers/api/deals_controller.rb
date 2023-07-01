class Api::DealsController < Api::BaseController
  
  def live 
    render json: Deal.live, each_serializer: DealSerializer
  end

  def past
    render json: Deal.expired, each_serializer: DealSerializer
  end
end
