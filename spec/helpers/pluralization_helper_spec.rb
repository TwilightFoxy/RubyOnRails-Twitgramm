require 'rails_helper'

RSpec.describe PluralizationHelper, type: :helper do
  describe '#russian_pluralize' do
    context 'when number ends in 1' do
      it 'returns the one form' do
        expect(helper.russian_pluralize(1, 'яблоко', 'яблока', 'яблок')).to eq('яблоко')
      end
    end

    context 'when number ends in 2-4' do
      it 'returns the few form' do
        expect(helper.russian_pluralize(2, 'яблоко', 'яблока', 'яблок')).to eq('яблока')
        expect(helper.russian_pluralize(3, 'яблоко', 'яблока', 'яблок')).to eq('яблока')
        expect(helper.russian_pluralize(4, 'яблоко', 'яблока', 'яблок')).to eq('яблока')
      end
    end

    context 'when number ends in 5-9, 0, or 11-14' do
      it 'returns the many form' do
        expect(helper.russian_pluralize(5, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
        expect(helper.russian_pluralize(6, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
        expect(helper.russian_pluralize(11, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
        expect(helper.russian_pluralize(12, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
        expect(helper.russian_pluralize(13, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
        expect(helper.russian_pluralize(14, 'яблоко', 'яблока', 'яблок')).to eq('яблок')
      end
    end
  end
end
