defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.SettingsTest do
  use <%= inspect context.web_module %>.ConnCase<%= test_case_options %>

  alias <%= inspect context.module %>
  import Phoenix.LiveViewTest
  import <%= inspect context.module %>Fixtures

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_<%= schema.singular %>(<%= schema.singular %>_fixture())
        |> live(~p"<%= schema.route_prefix %>/settings")

      assert html =~ "Change Email"
      assert html =~ "Save Password"
    end

    test "redirects if <%= schema.singular %> is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"<%= schema.route_prefix %>/log-in"
      assert %{"error" => "You must log in to access this page."} = flash
    end

    test "redirects if <%= schema.singular %> is not in sudo mode", %{conn: conn} do
      {:ok, conn} =
        conn
        |> log_in_<%= schema.singular %>(<%= schema.singular %>_fixture(),
          token_authenticated_at: <%= inspect datetime_module %>.add(<%= datetime_now %>, -11, :minute)
        )
        |> live(~p"<%= schema.route_prefix %>/settings")
        |> follow_redirect(conn, ~p"<%= schema.route_prefix %>/log-in")

      assert conn.resp_body =~ "You must re-authenticate to access this page."
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      %{conn: log_in_<%= schema.singular %>(conn, <%= schema.singular %>), <%= schema.singular %>: <%= schema.singular %>}
    end

    test "updates the <%= schema.singular %> email", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      new_email = unique_<%= schema.singular %>_email()

      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      result =
        lv
        |> form("#email_form", %{
          "<%= schema.singular %>" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~ "A link to confirm your email"
      assert <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(<%= schema.singular %>.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "<%= schema.singular %>" => %{"email" => "with spaces"}
        })

      assert result =~ "Change Email"
      assert result =~ "must have the @ sign and no spaces"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      result =
        lv
        |> form("#email_form", %{
          "<%= schema.singular %>" => %{"email" => <%= schema.singular %>.email}
        })
        |> render_submit()

      assert result =~ "Change Email"
      assert result =~ "did not change"
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      %{conn: log_in_<%= schema.singular %>(conn, <%= schema.singular %>), <%= schema.singular %>: <%= schema.singular %>}
    end

    test "updates the <%= schema.singular %> password", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      new_password = valid_<%= schema.singular %>_password()

      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      form =
        form(lv, "#password_form", %{
          "<%= schema.singular %>" => %{
            "email" => <%= schema.singular %>.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn, 303) == ~p"<%= schema.route_prefix %>/settings"

      assert get_session(new_password_conn, :<%= schema.singular %>_token) != get_session(conn, :<%= schema.singular %>_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert <%= inspect context.alias %>.get_<%= schema.singular %>_by_email_and_password(<%= schema.singular %>.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "<%= schema.singular %>" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ "Save Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"<%= schema.route_prefix %>/settings")

      result =
        lv
        |> form("#password_form", %{
          "<%= schema.singular %>" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Save Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      <%= schema.singular %> = <%= schema.singular %>_fixture()
      email = unique_<%= schema.singular %>_email()

      token =
        extract_<%= schema.singular %>_token(fn url ->
          <%= inspect context.alias %>.deliver_<%= schema.singular %>_update_email_instructions(%{<%= schema.singular %> | email: email}, <%= schema.singular %>.email, url)
        end)

      %{conn: log_in_<%= schema.singular %>(conn, <%= schema.singular %>), token: token, email: email, <%= schema.singular %>: <%= schema.singular %>}
    end

    test "updates the <%= schema.singular %> email once", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>, token: token, email: email} do
      {:error, redirect} = live(conn, ~p"<%= schema.route_prefix %>/settings/confirm-email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"<%= schema.route_prefix %>/settings"
      assert %{"info" => message} = flash
      assert message == "Email changed successfully."
      refute <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(<%= schema.singular %>.email)
      assert <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"<%= schema.route_prefix %>/settings/confirm-email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"<%= schema.route_prefix %>/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
    end

    test "does not update email with invalid token", %{conn: conn, <%= schema.singular %>: <%= schema.singular %>} do
      {:error, redirect} = live(conn, ~p"<%= schema.route_prefix %>/settings/confirm-email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"<%= schema.route_prefix %>/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
      assert <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(<%= schema.singular %>.email)
    end

    test "redirects if <%= schema.singular %> is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"<%= schema.route_prefix %>/settings/confirm-email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"<%= schema.route_prefix %>/log-in"
      assert %{"error" => message} = flash
      assert message == "You must log in to access this page."
    end
  end
end
