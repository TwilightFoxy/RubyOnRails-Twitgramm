$(document).on('ajax:success', 'form', function(event) {
    const postId = $(event.target).data('post-id');
    if (postId) {
        $(`#commentsModal-${postId}`).modal('show');
    }
});