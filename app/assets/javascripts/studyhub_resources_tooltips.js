$j(document).ready(function () {
    bindTooltips('body');

    $j('label.submit-required, span.submit-required').popover({
        html: false,
        animation: false,
        delay: {
            show: 500,
            hide: 100
        },
        trigger: 'hover',
        placement: 'auto right',
        container: 'body',
        content: 'This field is required before you can submit the resource.'
    });

    $j('label.save-required, span.save-required').popover({
        html: false,
        animation: false,
        delay: {
            show: 500,
            hide: 100
        },
        trigger: 'hover',
        placement: 'auto right',
        container: 'body',
        content: 'This field is required before you can save the resource.'
    });
});

function bindTooltips(root_tag) {
    $j(root_tag + ' [data-tooltip]').popover({
        html: false,
        animation: false,
        trigger: 'hover',
        placement: 'auto right',
        container: 'body',
        delay: {
            show: 500,
            hide: 100
        },
        content: function () {
            return $j(this).data('tooltip');
        }
    });
};