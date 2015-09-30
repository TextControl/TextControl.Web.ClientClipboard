using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace tx_zeroclipboard
{
    public partial class index : System.Web.UI.Page
    {
        protected void dummyButton_Click(object sender, EventArgs e)
        {
            // save the selection as RTF text
            string newvalue = "";
            TextControl1.Selection.Save(out newvalue, TXTextControl.Web.StringStreamType.RichTextFormat);
            // fill the hidden textbox with the RTF string
            TextBox1.Text = newvalue;

            // call the attachZeroClipboard() function to update ZeroClipboard
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "CallAttachZeroClipboard", "attachZeroClipboard(); toggleClipboardDropDown();", true);
        }
    }
}