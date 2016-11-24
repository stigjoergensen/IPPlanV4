Imports Microsoft.VisualBasic
Imports Telerik.Web.UI


Public Class test
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim treeList As New RadTreeList()

        Dim templateColumn As TreeListTemplateColumn
        templateColumn = New TreeListTemplateColumn()
        templateColumn.HeaderText = "Home Phone"
        templateColumn.DataField = "HomePhone"
        templateColumn.UniqueName = "HomePhone"
        templateColumn.ItemTemplate = New PhoneTemplateColumn(templateColumn.DataField)
        templateColumn.EditItemTemplate = New PhoneEditableTemplate(templateColumn.DataField)
        treeList.Columns.Add(templateColumn)

    End Sub


    Private Class PhoneTemplateColumn
        Implements ITemplate
        Protected phoneNumber As LiteralControl
        Private colName As String

        Public Sub New(ByVal cName As String)
            colName = cName
        End Sub

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements ITemplate.InstantiateIn
            phoneNumber = New LiteralControl()
            phoneNumber.ID = "phoneLbl"
            AddHandler phoneNumber.DataBinding, AddressOf phoneNumber_DataBinding
            container.Controls.Add(phoneNumber)
        End Sub

        Private Sub phoneNumber_DataBinding(ByVal sender As Object, ByVal e As EventArgs)
            Dim lbl As LiteralControl = DirectCast(sender, LiteralControl)
            Dim container As TreeListDataItem = DirectCast(lbl.NamingContainer, TreeListDataItem)
            lbl.Text = DirectCast(container.DataItem, DataRowView)("HomePhone").ToString()
        End Sub
    End Class

    Private Class PhoneEditableTemplate
        Implements IBindableTemplate
        Private phoneMask As RadMaskedTextBox
        Private colName As String

        Public Sub New(ByVal cName As String)
            colName = cName
        End Sub

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements ITemplate.InstantiateIn
            phoneMask = New RadMaskedTextBox()
            phoneMask.ID = "phoneTxt"
            phoneMask.Mask = "(###) ###-####"
            AddHandler phoneMask.DataBinding, AddressOf phoneMask_DataBinding
            container.Controls.Add(phoneMask)
        End Sub

        Private Sub phoneMask_DataBinding(ByVal sender As Object, ByVal e As EventArgs)
            Dim txt As RadMaskedTextBox = DirectCast(sender, RadMaskedTextBox)
            Dim container As TreeListEditableItem = DirectCast(txt.NamingContainer, TreeListEditableItem)
            txt.TextWithLiterals = DirectCast(container.DataItem, DataRowView)("HomePhone").ToString()
        End Sub

        Public Function ExtractValues(ByVal control As System.Web.UI.Control) As IOrderedDictionary Implements IBindableTemplate.ExtractValues
            Dim values As New OrderedDictionary()
            values(colName) = phoneMask.TextWithLiterals
            Return values
        End Function
    End Class

End Class
