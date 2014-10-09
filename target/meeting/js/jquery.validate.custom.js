jQuery.extend(jQuery.validator.messages, {
    required: "Campo Obrigat&#243;rio.",
    remote: "Por favor, corrija este campo.",
    email: "Por favor, informe um endere&#231;o de email v&#225;lido.",
    url: "Por favor, informe uma URL v&#225;lida.",
    date: "Por favor, informa uma data v&#225;lida.",
    dateISO: "Por favor, informa uma data v&#225;lida (ISO).",
    number: "Por favor, informa um n&#250;mero v&#225;lido.",
    digits: "Por valor, informa apenas dig&#237;tos.",
    creditcard: "Por favor, informe um n&#250;mero de cart&#227;o de cr&#233;dito v&#225;lido.",
    equalTo: "Por favor, informa o mesmo valor..",
    accept: "Por favor, informa um valor de extens&#227;o v&#225;lido.",
    maxlength: jQuery.validator.format("Por favor, n&#227;o informe mais do que {0} caracteres."),
    minlength: jQuery.validator.format("Por favor, informa ao menos {0} caracteres."),
    rangelength: jQuery.validator.format("Por favor, entre com um valor entre {0} e {1} caracteres."),
    range: jQuery.validator.format("Por favor, entre com um valor entre {0} e {1} caracteres."),
    max: jQuery.validator.format("Por favor, informe um valor menor ou igual a {0}."),
    min: jQuery.validator.format("Por favor, informe um valor maior ou igual a {0}.")
});