require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'Get Index' do
    it 'assigns @courses' do
      course1 = create(:course)
      course2 = create(:course)

      get :index

      expect(assigns[:courses]).to eq([course1, course2])

    end

    it 'render template' do
      course1 = create(:course)
      course2 = create(:course)

      get :index

      expect(response).to render_template("index")
    end
  end

  describe 'Get Show' do
    it 'assigns @course' do
      course = create(:course)

      get :show, params: {id: course.id}
      expect(assigns[:course]).to eq(course)
    end

    it 'render template' do
      course = create(:course)

      get :show, params: {id: course.id}
      expect(response).to render_template("show")

    end
  end

  describe 'Get New' do
    context 'when user login' do
      it 'assigns @course' do
        user = create(:user)
        course = build(:course)
        sign_in user
        get :new

        expect(assigns[:course]).to be_a_new(Course)
      end

      it 'render template' do
        user = create(:user)
        course = build(:course)
        sign_in user
        get :new

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
      it 'create a new course record ' do
        course = build(:course)

        expect do
          post :create, params: { course: attributes_for(:course) }
        end.to change{ Course.count }.by(1)
      end

      it 'redirect to courses_path' do
        course = build(:course)

        post :create, params: { course: attributes_for(:course) }
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe 'Get Edit' do
    it 'assign coures' do
      course = create(:course)
      get :edit, params: { id: course.id }

      expect(assigns[:course]).to eq(course)
    end

    it 'render temlpate' do
      course = create(:course)
      get :edit, params: { id: course.id }

      expect(response).to render_template("edit")
    end
  end

  describe 'PUT Update' do
    context 'when course does not have title' do
      it 'does not update a record' do
        course = create(:course)
        put :update, params: { id: course.id, course: { title: "", description: "Description" } }

        expect(course.description).not_to eq("Description")
      end

      it 'render edit template' do
        course = create(:course)
        put :update, params: { id: course.id, course: { title: "", description: "Description" } }

        expect(response).to render_template("edit")
      end
    end

    context 'when course has title' do
      it 'assign @course' do
        course = create(:course)

        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }
        expect(assigns[:course]).to eq(course)
      end

      it 'change value' do
        course = create(:course)
        put :update, params: { id: course.id, course: { title: "Title", description: "Description" } }

        expect(assigns[:course].title).to eq("Title")
        expect(assigns[:course].description).to eq("Description")
      end

      it 'redirect_to course_path' do
        course = create(:course)
        put :update, params: { id: course.id, course: { title: "Titile", description: "Description" } }

        expect(response).to redirect_to course_path(course)
      end
    end
  end


  describe 'DELETE destroy' do
    it 'assign @course' do
      course = create(:course)
      delete :destroy, params: { id: course.id }

      expect(assigns[:course]).to eq(course)
    end

    it 'delete a record' do
      course = create(:course)

      expect { delete :destroy, params: { id: course.id } }.to change { Course.count }.by(-1)
    end

    it 'redirect_to courses_path' do
      course = create(:course)
      delete :destroy, params: { id: course.id }

      expect(response).to redirect_to courses_path
    end
  end
end
