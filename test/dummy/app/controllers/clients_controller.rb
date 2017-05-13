class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  #autocomplete :client, :name
  #autocomplete :client, :name, { :where_method => :w_region }
  #autocomplete :client, :name, {order: Proc.new { params[:myorder] || 'id' }}
  autocomplete :client, :name, { :where => 'company_id=1' }
  #autocomplete :client, :name, {extra_columns: ['id', 'name'], display_id: 'id', display_value: 'name'}

  def w_region
    # get value from params
    v = params[:company_id]

    if v
      w = "id=#{v}"
    else
      w = nil
    end

    w
  end


  def temp_autocomplete_client_name
    a = [["123","First"],["456","Second"], ["3", "Third"]]
    render :json => a.to_json
  end

  def example1_autocomplete_client_name
    # your options
    model = Client
    options = {
        display_id: 'id',
        display_value: 'name',
        limit: 10,
        order: 'name ASC'
    }


    # input
    q = params[:q] || ''

    # change your query
    #where = "your custom query here"
    where = ["LOWER(name) LIKE ?", "#{q.downcase}%"] # basic query

    limit   = autocomplete_option_limit(options)
    order   = options[:order] || "id ASC"


    # get rows from DB
    items = model.where(where).order(order).limit(limit)

    #
    method_display_value = options[:display_value] if options.has_key?(:display_value)
    #method_display_value ||= method

    method_display_id = options[:display_id] if options.has_key?(:display_id)
    method_display_id ||= model.primary_key

    data = items.map do |item|
      v = item.send(method_display_value)
      id = item.send(method_display_id)

      [id.to_s, v.to_s]
    end

    render :json => data.to_json
  end

  # GET /clients
  def index
    @clients = Client.all
  end

  # GET /clients/1
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params[:client].permit(:name)
    end
end
