require 'rails_helper'

RSpec.describe OutputLogController, :type => :controller do
  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "OutputToLogController test"
    it "1-1.output_log_route_guidance 正常系" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: 1, to_geometry_id: 103, to_floor_id: 1043
    end
    
    it "1-2.output_log_route_guidance from_geometry_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: 1, to_geometry_id: 103, to_floor_id: 1043
    end

    it "1-3.output_log_route_guidance from_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: '', to_geometry_id: 103, to_floor_id: 1043
    end

    it "1-4.output_log_route_guidance to_geometry_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: 1, to_geometry_id: '', to_floor_id: 1043
    end

    it "1-5.output_log_route_guidance to_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: 1, to_geometry_id: 103, to_floor_id: ''
    end

    it "1-6.output_log_route_guidance from_geometry_id、from_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: '', to_geometry_id: 103, to_floor_id: 1043
    end

    it "1-7.output_log_route_guidance from_geometry_id、to_geometry_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: 1, to_geometry_id: '', to_floor_id: 1043
    end

    it "1-8.output_log_route_guidance from_geometry_id、to_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: 1, to_geometry_id: 103, to_floor_id: ''
    end

    it "1-9.output_log_route_guidance from_geometry_id、from_floor_id、to_geometry_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: '', to_geometry_id: '', to_floor_id: 1043
    end

    it "1-10.output_log_route_guidance from_geometry_id、from_floor_id、to_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: '', from_floor_id: '', to_geometry_id: 103, to_floor_id: ''
    end

    it "1-11.output_log_route_guidance from_floor_id、to_geometry_id、to_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: '', to_geometry_id: '', to_floor_id: ''
    end

    it "1-12.output_log_route_guidance from_floor_id、to_geometry_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: '', to_geometry_id: '', to_floor_id: 1045
    end

    it "1-13.output_log_route_guidance from_floor_id、to_floor_idが未入力" do
      post :output_log_route_guidance, lang: 'ja', from_geometry_id: 1, from_floor_id: 2, to_geometry_id: '', to_floor_id: ''
    end

    it "2-1.output_log_chinese_concierge 正常系" do
      post :output_log_chinese_concierge, lang: 'ja', cc_narrow_num: 10
    end

    it "2-2.output_log_chinese_concierge cc_narrow_numが未入力" do
      post :output_log_chinese_concierge, lang: 'ja', cc_narrow_num: ''
    end

    it "3-1.output_log_dfs_search 正常系" do
      post :output_log_dfs_search, lang: 'ja', dfs_narrow_num: 7
    end

    it "3-2.output_log_dfs_search dfs_narrow_numが未入力" do
      post :output_log_dfs_search, lang: 'ja', dfs_narrow_num: ''
    end
end
