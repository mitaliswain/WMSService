module Putaway

  require 'utilities/utility'
  require 'utilities/response'

  class CasePutaway

    include CasePutawayProcessing
    include CasePutawayValidation
    include Response
    include Utility

    attr_accessor :message, :error, :putaway
    FAILED_TO_PROCESS = 'false'

    def initialize(putaway)
      @message = {}
      @error = []
      @putaway = putaway
    end

  end
end