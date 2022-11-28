class NodeCountController < ApplicationController
    def show
        map = Hash.new(0)
        map['89ef556-dfff-4ff2-9733-654645be56fe'] += 1
        queue = ['089ef556-dfff-4ff2-9733-654645be56fe']
        until queue.empty?
            uuid = queue.pop
            response = send_request(uuid)
            response.each do |res|
                res['child_node_ids'].each do |node_id|
                    map[node_id] += 1
                    if map[node_id] == 1
                        queue << node_id
                    end
                end
            end
        end
        map
    end

    def send_request(uuid)
        response = HTTParty.get("https://nodes-on-nodes-challenge.herokuapp.com/nodes/#{uuid}")
        response.parsed_response
    end
end