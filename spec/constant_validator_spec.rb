require 'spec_helper'

module RailsParamValidation

  RSpec.describe ConstantValidator do

    [
        [[true], [false, "", 42, 42.5]],
        [[false], [true, "", 42, 42.5]],
        [[42], [23, "", true, 42.5]],
        [["abc", :abc], ["def", :def]],
        [[:abc, "abc"], [:def, "def"]]
    ].each do |set|

      context "constants of type #{set.first.first.class}" do
        before(:each) do
          @validator = ValidatorFactory.create set.first.first
        end

        set.first.each do |v|
          it "should accept #{v.inspect} for #{set.first.first}" do
            match = @validator.matches?([], v)
            expect(match.matches?).to eq(true)
            expect(match.value).to eq(set.first.first)
          end
        end

        set.last.each do |v|
          it "should not accept #{v.inspect} for #{set.first.first}" do
            match = @validator.matches?([], v)
            expect(match.matches?).to eq(false)
            expect(match.value).to eq(nil)
          end
        end
      end


    end

  end
end

