<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="tx_zeroclipboard.index" %>

<%@ Register assembly="TXTextControl.Web, Version=22.0.200.500, Culture=neutral, PublicKeyToken=6b83fe9a75cfb638" namespace="TXTextControl.Web" tagprefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>TX Text Control and ZeroClipboard</title>
    <script src="Scripts/jquery-2.1.4.js"></script>
    <script type="text/javascript" src="Scripts/ZeroClipboard.js"></script>
</head>
<body>
    <div>
        <form runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <!-- dummy button to handle AJAX calls easily server-side -->
                        <asp:Button style="visibility: hidden;" ID="dummyButton" runat="server" OnClick="dummyButton_Click" />
                        <!-- a hidden text box that is filled from server-side with the
                            selected RTF content -->
                        <asp:TextBox style="visibility: hidden;" ID="TextBox1" runat="server"></asp:TextBox>
                    </ContentTemplate>
                </asp:UpdatePanel>

            <cc1:TextControl ID="TextControl1" runat="server" Dock="Window" />

            <script type="text/javascript">

                // wait, until the TX Text Control has been loaded completely
                TXTextControl.addEventListener("ribbonTabsLoaded", function (e) {
                    addButtonsToDOM();
                    toggleClipboardDropDown();
                    attachZeroClipboard();
                });

                // toggles the drop down button
                function toggleClipboardDropDown() {
                    if ($("#clipboardDropDown").css("visibility") == "hidden") {
                        $("#clipboardDropDown").css("visibility", "visible");

                        $(document).mouseup(function (e) {
                            var container = $("#clipboardDropDown");

                            if (!container.is(e.target)
                                && container.has(e.target).length === 0)
                            {
                                $("#clipboardDropDown").css("visibility", "hidden");
                            }
                        });
                    }
                    else
                        $("#clipboardDropDown").css("visibility", "hidden");
                }

                //  shows a message box
                function showMessage(text) {
                    var elemContainer = document.getElementById("txTemplateDesignerContainer");
                    var elemMsg = document.createElement("DIV");
                    elemMsg.id = "txErrMsgDiv";
                    elemMsg.classList.add("unselectable");
                    elemMsg.style.zIndex = "9999";
                    text = text.replace(/\r?\n/g, "<br />");
                    elemMsg.innerHTML = text;
                    elemContainer.appendChild(elemMsg);

                    elemMsg.style.marginTop = -(elemMsg.clientHeight / 2) + "px";
                    elemMsg.style.marginLeft = -(elemMsg.clientWidth / 2) + "px";

                    fadeOutAndRemove(elemMsg, elemContainer, 1000, 1000);
                }

                // fades out the message box
                function fadeOutAndRemove(elem, elemContainer, delay, time) {
                    elem.style.transition = "opacity " + (time / 1000) + "s";
                    setTimeout(function () {
                        elem.style.opacity = 0;
                        setTimeout(function () {
                            elemContainer.removeChild(elem);
                        }, time);
                    }, delay);
                }

                // this function adds new buttons to the Clipboard ribbon group
                function addButtonsToDOM() { 
                    sClipboardBtn = '<div id="zeroClipboardCopy" class="ribbon-button ribbon-button-big"><div class="ribbon-button-big-image-container"><img src="images/clipboard_copy_client.png" class="ribbon-button-big-image" /></div><div class="ribbon-button-big-label-container"><p class="ribbon-button-label"><span class="ribbon-button-label-text">Copy to Client<br /> Clipboard</span><span class="drop-down-arrow-large"> ▼</span></p></div></div></div>';
                    sClipboardDropDown = '<ul style="cursor: pointer; visibility: visible; display: block; width: 227px; top: 95px; left: 13px;" tabindex="0" role="menu" id="clipboardDropDown" class="dropDownMenu ui-menu ui-widget ui-widget-content ui-corner-all"><li aria-disabled="false" role="presentation" id="mnuItemClientClipboard" class="ui-menu-item"><a role="menuitem" tabindex="-1" class="ui-state-focus ui-corner-all" id="ui-id-44" href="#!"><div class="large-menu-item-image-container-long-caption"><img src="images/clipboard_copy_client.png"></div><div class="large-menu-item-long-caption-container"><h1>Copy to Client Clipboard</h1><p>Copies the selected content<br/>to the client clipboard.</p></div></a></li></ul>';

                    // add the new button to the DOM 
                    document.getElementById('drpDnBtnPaste').insertAdjacentHTML(
                        'beforebegin', sClipboardBtn);

                    // add the drop down to the DOM
                    document.getElementById('drpDnBtnPaste').insertAdjacentHTML(
                        'beforebegin', sClipboardDropDown);
 
                    // force a post back on the invisible button 
                    document.getElementById("zeroClipboardCopy").addEventListener(
                        "click", 
                        function () { __doPostBack('<%= dummyButton.ClientID %>', ''); }); 
                }

                // this function attaches the ZeroClipboard plugin
                // to the newly created button and handles the events
                function attachZeroClipboard() {
                    var sRTFToCopy = $("#TextBox1").val();
                    var client = new ZeroClipboard(document.getElementById('clipboardDropDown'));
                    
                    client.on('ready', function (event) {

                        client.on('copy', function (event) {
                            event.clipboardData.setData('application/rtf', sRTFToCopy);
                        });

                        client.on('aftercopy', function (event) {
                            showMessage("Formatted content has been copied to the client clipboard.");
                            $("#clipboardDropDown").css("visibility", "hidden");
                        });
                    });

                    client.on('error', function (event) {
                        ZeroClipboard.destroy();
                    });
                }

            </script>
        </form>
    </div>
</body>
</html>
