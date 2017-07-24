require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'Get Index' do
    let(:course1) { create(:course) }
    let(:course2) { create(:course) }
    before do
      get :index

    end
    it 'assigns @courses' do
      expect(assigns[:courses]).to eq([course1, course2])
    end

    it 'render template' do
      expect(response).to render_template("index")
    end
  end

  describe 'Get Show' do
    let(:course) {  create(:course) }
    before do
      get :show, params: {id: course.id}
    end

    it 'assigns @course' do
      expect(assigns[:course]).to eq(course)
    end

    it 'render template' do
      expect(response).to render_template("show")
    end
  end

  describe 'Get New' do
    context 'when user login' do
      let(:user) { create(:user) }
      let(:course) { build(:course) }
      before do
        sign_in user
        get :new
      end

      it 'assigns @course' do
        expect(assigns[:course]).to be_a_new(Course)
      end

      it 'render template' do
        expect(response).to render_template("new")
      end
    end

    context 'when user not login' do
      it 'redirect_to new_user_session_path' do
        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'Post Create' do
    let(:user) { create(:user) }
    before { sign_in user }
    context 'when course does not have title' do
      it 'dose not create a record' do

        expect do
          post :create, params: { course: { description: "bar" } }
        end.to change { Course.count }.by(0)

      end

      it 'render new template' do

        post :create, params: { course: { description: "bar" } }
        expect(response).to render_template("new")

      end
    end
    context 'when course has title' do
      let(:course) { build(:course) }

      it 'create a new course record ' do
        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change{ Course.count }.by(1)
      end

      it 'redirect to courses_path' do
        post :create, params: { course: attributes_for(:course) }
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe 'Get Edit' do
    let(:course) { create(:course) }
    before do
      get :edit, params: { id: course.id }
    end
    it 'assign course' do
      expect(assigns[:course]).to eq(course)
    end

    it 'render temlpate' do
      expect(response).to render_template("edit")
    end
  end

  describe 'PUT Update' do
    context 'when course does not have title' do
      let(:course) { create(:course) }
      before do
        put :update, params: { id: course.id, course: { title: "", description: "Description" } }
      end
      it 'does not update a record' do
        expect(course.description).not_to eq("Description")
      end

      it 'render edit template' do
        expect(response).to render_template("edit")
      end
    end

    context 'when course has title' do
      let(:course) { create(:course) }
      before do
        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
      end
      it 'assign @course' do
        expect(assigns[:course]).to eq(course)
      end

      it 'change value' do
        expect(assigns[:course].title).to eq("Title")
        expect(assigns[:course].description).to eq("Description")
      end

      it 'redirect_to course_path' do
        expect(response).to redirect_to course_path(course)
      end
    end
  end


  describe 'DELETE destroy' do
    let!(:course) { create(:course) }
    it 'assign @course' do

      delete :destroy, params: { id: course.id }

      expect(assigns[:course]).to eq(course)
    end

    it 'delete a record' do

      expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
    end

    it 'redirect_to courses_path' do

      delete :destroy, params: { id: course.id }

      expect(response).to redirect_to courses_path
    end
  end
end
