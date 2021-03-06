# frozen_string_literal: true

module Getonbrd
  module Public
    class Tag < Resource
      has_many :jobs, class_name: "Public::Job"
    end
  end
end
