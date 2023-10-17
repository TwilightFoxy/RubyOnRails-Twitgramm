$(document).on('input', '.new-post-textarea, .comment-form textarea', function() {
    const $this = $(this);
    $this.closest('form').find('[type="submit"]').prop('disabled', !$this.val().trim());
});

$(window).on('load', function() {
    const hash = window.location.hash;
    if (hash && hash.startsWith("#post-")) {
        const postId = hash.split("-")[1];
        const modal = $(`#commentsModal-${postId}`);
        if (modal.length) {
            modal.modal('show');
        }
    }
});