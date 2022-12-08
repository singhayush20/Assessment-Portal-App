import 'package:assessmentportal/AppConstants/constants.dart';

const sendEmailOTPUrl =
    "$domain/assessmentportal/authenticate/verifyemail/sendotp";
const verifyEmailOTPUrl =
    "$domain/assessmentportal/authenticate/verifyemail/verify-otp";
const registerNormalUserUrl =
    "$domain/assessmentportal/authenticate/register/normal";
const registerAdminUserUrl =
    "$domain/assessmentportal/authenticate/register/admin?key=adminKey";
const forgetPasswordSendOTPUrl =
    "$domain/assessmentportal/authenticate/verifyemail/reset-password-otp";
const verifyForgetPasswordSendOTPUrl =
    "$domain/assessmentportal/authenticate/verifyemail/reset-password";
const loginUserUrl = "$domain/assessmentportal/authenticate/login";
const loadUserByEmailUrl = "$domain/assessmentportal/users/";
const updateUserUrl = "$domain/assessmentportal/users/update";
const getAllCategoriesUrl = "$domain/assessmentportal/category/all";
const getQuizzesForCategoryUrl = "$domain/assessmentportal/quiz/getByCategory";
const getQuizzesForCategoryandActiveUrl =
    "$domain/assessmentportal/quiz/active";
const addNewCategoryUrl = "$domain/assessmentportal/category/create";
const loadQuizzesAdminUrl = "$domain/assessmentportal/quiz/getByAdmin/";
const addNewQuizUrl = "$domain/assessmentportal/quiz/create";
const deleteQuizUrl = "$domain/assessmentportal/quiz/delete";
const updateQuizUrl = "$domain/assessmentportal/quiz/update";
const deleteCategoryUrl = '$domain/assessmentportal/category/delete';
const updateCategoryUrl = "$domain/assessmentportal/category/update";
const enrollInCateogryUrl =
    "$domain/assessmentportal/users/enrolledcategories/all/add";
const getAllEnrolledCategoriesUrl =
    '$domain/assessmentportal/users/enrolledcategories/all';
const loadQuestionsUrl = '$domain/assessmentportal/question/quiz';
const addQuestionUrl = '$domain/assessmentportal/question/create';
const updateQuestionUrl = '$domain/assessmentportal/question/update';
const deleteQuestionUrl = '$domain/assessmentportal/question/delete';
const evaluateQuizUrl = '$domain/assessmentportal/question/evaluate-quiz';
const checkQuizAttemptUrl = '$domain/assessmentportal/quizresult/check-attempt';
const getAllAttemptedQuizzesUrl =
    '$domain/assessmentportal/quizresult/getByUser';
const getAllUsersForQuizUrl = '$domain/assessmentportal/quizresult/getByQuiz';
