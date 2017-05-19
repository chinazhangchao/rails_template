// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require semantic-ui
//= require jquery.form
//= require_tree .
$(document).ready(function() {
    var dropdownSetting = {
        forceSelection: false,
        fullTextSearch: true,
        message: {
            count: '{count} 个已选择',
            maxSelections: '最多选择 {maxCount} 个元素',
            noResults: '没有匹配结果'
        }
    };

    $('.ui.dropdown').dropdown(dropdownSetting);

    $(document).on("keydown", ".ui.dropdown input.search", function(e) { 
        var search_input = e.target
        if (e.keyCode == 8 && search_input.value == '') {
            $(search_input.parentElement).dropdown('clear');
        };
    });

    var vbDropdownSetting = {};
    $.extend(true, vbDropdownSetting, dropdownSetting);
    vbDropdownSetting.onChange = function(value, text, $choice) {
        $.ajax({
            url: '/vehicle/factories/dropdown?vehicle_brand_id=' + value,
            type: 'GET',
            success: function(obj) {
                targetDropdown = $("#vehicleFactory");
                targetDropdown.children().remove();
                var str = '<input type="hidden" id="q_vehicle_factory_id_eq" name="q[vehicle_factory_id_eq]" value="">' +
                    '<i class="dropdown icon"></i>' +
                    '<input class="search" autocomplete="off" tabindex="0">' +
                    '<div class="default text">厂商</div>' +
                    '<div class="menu transition hidden">';
                for (i = 0; i < obj.length; i++) {
                    str += ("<div class='item' data-value='" + obj[i].id + "'>" + obj[i].name + "</div>");
                }

                str += '</div>';
                targetDropdown.append(str);
                targetDropdown.dropdown(dropdownSetting);
            }
        })
    }
    $('#vehicleBrand').dropdown(vbDropdownSetting);
    $(".ui.promptmodel").fadeOut(3000);
    checkflag = 0;
});

var checkflag = 0;
var checkdLen;

function checkAll(_this) {
    checkdLen = $(".info-table tbody tr").length;
    if (_this.checked) {
        $('.checked').each(function() {
            this.checked = true;
        });
        checkflag = checkdLen;
    } else {
        $('.checked').each(function() {
            this.checked = false;
        });
        checkflag = 0;
    }
}

function check(_this) {
    checkdLen = $(".info-table tbody tr").length;
    if (_this.checked) {
        checkflag += 1;
        if (checkflag == checkdLen) {
            $(".checkedAll").prop("checked", true);
        }
    } else {
        checkflag -= 1;
        if (checkflag != checkdLen) {
            $(".checkedAll").prop("checked", false);
        }
    }
}
// 图片上传
function uploadimg(_this, type, max) {
    var imgNumber = $('.image-container').length;

    if ($(_this).val() != '') {
        if (max - imgNumber < _this.files.length) {
            $('.cancel').hide();
            prompt('最多上传' + max + '张图片', function() {
                $('.small.modal').modal('hide')
            });
        } else {
            var formData = new FormData();
            formData.append('type', type);
            for (var i = 0; i < _this.files.length; i++) {
                var key = 'img' + i;
                formData.append(key, _this.files[i]);
            }
            $.ajax({
                url: 'http://182.92.161.89:9103/up',
                type: 'POST',
                cache: false,
                data: formData,
                processData: false,
                contentType: false,
                beforeSend: function() {
                    $('.upload_loading_wrap').show();
                }
            }).done(function(obj) {
                var str = "";
                $('.upload_loading_wrap').hide();
                for (var i = 0; i < _this.files.length; i++) {
                    str += '<div class="image-container">' +
                        '<div class="ui tiny images">' +
                        '<image  src="http://image.chechebijia.com/images/' + obj.result['img' + i].innerUrl + '"/>' +
                        '</div>' +
                        '<div class="remove-container" onclick="removeImg(this)">' +
                        '<i class="remove circle icon tiny"></i>' +
                        '</div>' +
                        '<input type="text" name="vehicle_brand[images][]" style="display:none" class="image-input" value="' + obj.result['img' + i].innerUrl + '"/>' +
                        '</div>';
                }
                $('.fieldset_div').append(str);
                $('.cancel').hide();
                prompt('上传成功!', function() {
                    $('.small.modal').modal('hide')
                });

            }).fail(function(xhr) {
                console.log(xhr);
                $('.upload_loading_wrap').hide();
                var msg = xhr.responseText;
                if (!msg) {
                    msg = '上传失败，请重新上传！';
                }
                $('.cancel').hide();
                prompt(msg, function() {
                    $('.small.modal').modal('hide')
                });
            });
        }

    }
}

//图片删除
function removeImg(_this) {
    $(_this).parent().remove();
    var length = $('.image-input').length;
    if (length == 0) {
        var str = '<input type="text" name="vehicle_brand[images][]" style="display:none" class="image-input" />';
        $('.fieldset_div').html(str);
    }
}

//弹出框
function prompt(html, successFunction) {
    $('.prompt-name').text(html);
    $('.small.modal').modal({
        closable: false,
        duration: 0,
        dimmerSettings: {
            opacity: 0.3
        },
        onDeny: function() {
            $('.small.modal').modal('hide');
        },
        onApprove: function() {
            successFunction();
        }
    }).modal('show');
}

//Override the default confirm dialog by rails
$.rails.allowAction = function(link) {
    if (link.data("confirm") == undefined) {
        return true;
    }
    $.rails.showConfirmationDialog(link);
    return false;
}

//User click confirm button
$.rails.confirmed = function(link) {
    link.data("confirm", null);
    link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link) {
    prompt(link.data("confirm"), function() {
        $('.small.modal').modal('hide');
        $.rails.confirmed(link);
    });
};

/*批量通过或驳回*/
function postAll(url, title) {
    $(".passclass").attr("action", url);
    prompt("确定" + title + "所选数据吗？", function() {
        $(".passclass").submit();
    });
}