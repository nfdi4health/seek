var SR = {

    removetitleRow: function () {
        var row = $j(this).parents('.resource-title');
        row.remove();
    },

    removedescriptionRow: function () {
        var row = $j(this).parents('.resource-description');
        row.remove();
    }


};